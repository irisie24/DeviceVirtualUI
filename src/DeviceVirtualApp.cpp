#include "DeviceVirtualApp.hpp"

DeviceVirtualApp* appptr = nullptr;

DeviceVirtualApp::DeviceVirtualApp(int argc, char *argv[])
    :QGuiApplication(argc, argv)
{
    appptr = this;
}

DeviceVirtualApp::~DeviceVirtualApp()
{
}

bool DeviceVirtualApp::Initialize()
{
    return true;
}
