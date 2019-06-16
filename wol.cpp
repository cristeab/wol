#include "wol.h"
#include <sys/socket.h>
#include <arpa/inet.h>

void Wol::send(const std::string& hardware_addr)
{
    // Fetch the hardware address.
    const std::string ether_addr{getEther(hardware_addr)};

    SocketHandle packet{socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)};

    // Build the message to send.
    //   (6 * 0XFF followed by 16 * destination address.)
    std::string message(6, 0xFF);
    for (size_t i = 0; i < 16; ++i) {
        message += ether_addr;
    }

    // Set socket options.
    const int optval{1};
    if (setsockopt(packet.get(), SOL_SOCKET, SO_BROADCAST, &optval, sizeof(optval)) < 0) {
        throw std::runtime_error("Failed to set socket options");
    }

    // Set up address
    sockaddr_in addr{};
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = _bcast;
    addr.sin_port = htons(_port);

    // Send the packet out.
    if (sendto(packet.get(), message.c_str(), message.length(), 0,
        reinterpret_cast<sockaddr*>(&addr), sizeof(addr)) < 0) {
        throw std::runtime_error("Failed to send packet");
    }
}

std::string Wol::getEther(const std::string& hardwareAddr)
{
    std::string ether_addr;

    for (size_t i = 0; i < hardwareAddr.length();) {
        // Parse two characters at a time.
        unsigned hex = getHexFromString(hardwareAddr.substr(i, 2));
        i += 2;

        ether_addr += static_cast<char>(hex & 0xFF);

        // We might get a colon here, but it is not required.
        if (hardwareAddr[i] == ':')
            ++i;
    }

    if (ether_addr.length() != 6)
        throw std::runtime_error(hardwareAddr + " not a valid ether address");

    return ether_addr;
}

unsigned Wol::getHexFromString(const std::string& s)
{
    unsigned hex{0};

    for (size_t i = 0; i < s.length(); ++i) {
        hex <<= 4;
        if (isdigit(s[i])) {
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
