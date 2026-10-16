#include "QtAppTemplate.hpp"

QtAppTemplate* apptempl = nullptr;

QtAppTemplate::QtAppTemplate(int argc, char *argv[])
    :QGuiApplication(argc, argv)
{
    apptempl = this;
}

QtAppTemplate::~QtAppTemplate()
{
}

bool QtAppTemplate::Initialize()
{
    return true;
}
