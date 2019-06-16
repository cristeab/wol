#pragma once

#include <string>
#include <unistd.h>

class Wol
{
public:
    void send(const std::string& hardware_addr);
private:
    class SocketHandle {
    public:
        explicit SocketHandle(int descriptor) : _descriptor(descriptor) {
            if (_descriptor < 0)
                throw std::runtime_error("Failed to open socket");
        }
        SocketHandle(const SocketHandle&) = delete;
        SocketHandle& operator=(const SocketHandle&) = delete;

        int get() const {
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
    unsigned _port{60000};
    unsigned int _bcast{0xFFFFFFFF};
};
