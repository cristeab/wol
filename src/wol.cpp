#include "wol.h"
#include <sys/socket.h>
#include <arpa/inet.h>
#include <cerrno>
#include <cctype>
#include <cstring>
#include <chrono>
#include <stdexcept>
#include <system_error>
#include <thread>

bool Wol::configure(const std::string& broadcastAddress, int port)
{
    if (port < 1 || port > 65535)
        return false;

    in_addr address{};
    if (inet_pton(AF_INET, broadcastAddress.c_str(), &address) != 1)
        return false;

    _bcast = address.s_addr;
    _port = static_cast<std::uint16_t>(port);
    return true;
}

void Wol::send(const std::string& hardware_addr)
{
    // Fetch the hardware address.
    const std::string ether_addr{getEther(hardware_addr)};

    SocketHandle packet{socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)};

    // Build the message to send.
    //   (6 * 0XFF followed by 16 * destination address.)
    const size_t addr_len = ether_addr.size();
    const size_t total    = 6 + 16 * addr_len;

    std::string message;
    message.resize_and_overwrite(total, [&](char* buf, size_t n) {
        std::memset(buf, 0xFF, 6);
        for (size_t i = 0; i < 16; ++i)
            std::memcpy(buf + 6 + i * addr_len, ether_addr.data(), addr_len);
        return n;
    });

    // Set socket options.
    const int optval{1};
    if (setsockopt(packet.get(), SOL_SOCKET, SO_BROADCAST, &optval, sizeof(optval)) < 0)
        throw std::system_error(errno, std::generic_category(), "Failed to set socket options");

    // Set up address
    sockaddr_in addr{.sin_family = AF_INET, .sin_port = htons(_port),
                     .sin_addr = {.s_addr = _bcast}};

    // Send the packet out.
    int lastError = 0;
    for (int attempt = 0; attempt < 3; ++attempt) {
        if (sendto(packet.get(), message.data(), message.length(), 0,
            reinterpret_cast<sockaddr*>(&addr), sizeof(addr)) >= 0)
            return;

        lastError = errno;
        const bool transientRouteError = lastError == EHOSTUNREACH ||
                                         lastError == ENETUNREACH ||
                                         lastError == ENETDOWN;
        if (!transientRouteError || attempt == 2)
            break;

        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    throw std::system_error(lastError, std::generic_category(), "Failed to send packet");
}

std::string Wol::getEther(const std::string& hardwareAddr)
{
    const auto isHex = [](char character) {
        return std::isxdigit(static_cast<unsigned char>(character)) != 0;
    };
    const bool unseparated = hardwareAddr.size() == 12;
    const bool separated = hardwareAddr.size() == 17 &&
                           (hardwareAddr[2] == ':' || hardwareAddr[2] == '-') &&
                           hardwareAddr[2] == hardwareAddr[5] &&
                           hardwareAddr[2] == hardwareAddr[8] &&
                           hardwareAddr[2] == hardwareAddr[11] &&
                           hardwareAddr[2] == hardwareAddr[14];
    if (!unseparated && !separated)
        throw std::runtime_error(hardwareAddr + " not a valid ether address");

    std::string ether_addr;
    ether_addr.reserve(6);
    for (size_t group = 0; group < 6; ++group) {
        const size_t offset = unseparated ? group * 2 : group * 3;
        if (!isHex(hardwareAddr[offset]) || !isHex(hardwareAddr[offset + 1]))
            throw std::runtime_error(hardwareAddr + " not a valid ether address");
        ether_addr += static_cast<char>(getHexFromString(hardwareAddr.substr(offset, 2)));
    }

    return ether_addr;
}

unsigned Wol::getHexFromString(const std::string& s)
{
    if (s.size() != 2)
        throw std::runtime_error("Failed to parse hexadecimal " + s);

    unsigned hex{0};

    for (size_t i = 0; i < s.length(); ++i) {
        hex <<= 4;
        if (std::isdigit(static_cast<unsigned char>(s[i]))) {
            hex |= static_cast<unsigned>(s[i] - '0');
        }
        else if (s[i] >= 'a' && s[i] <= 'f') {
            hex |= static_cast<unsigned>(s[i] - 'a') + 10;
        }
        else if (s[i] >= 'A' && s[i] <= 'F') {
            hex |= static_cast<unsigned>(s[i] - 'A') + 10;
        }
        else {
            throw std::runtime_error("Failed to parse hexadecimal " + s);
        }
    }
    return hex;
}
