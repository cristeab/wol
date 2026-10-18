#pragma once

#include <cstdint>
#include <stdexcept>
#include <string>
#include <unistd.h>

class Wol
{
public:
    void send(const std::string& hardware_addr);
    bool configure(const std::string& broadcastAddress, int port);
private:
    class SocketHandle {
    public:
        explicit SocketHandle(int descriptor) : _descriptor(descriptor) {
            if (_descriptor < 0)
                throw std::runtime_error("Failed to open socket");
        }
        SocketHandle(const SocketHandle&) = delete;
        SocketHandle& operator=(const SocketHandle&) = delete;
        SocketHandle(SocketHandle&&) = delete;
        SocketHandle& operator=(SocketHandle&&) = delete;

        constexpr int get() const {
            return _descriptor;
        }

        ~SocketHandle() {
            close(_descriptor);
        }
    private:
        const int _descriptor;
    };
    std::string getEther(const std::string& hardwareAddr);
    unsigned getHexFromString(const std::string& s);
    std::uint16_t _port{60000};
    std::uint32_t _bcast{0xFFFFFFFFu};
};
