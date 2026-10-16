#include "UserInfo.hpp"

UserInfo::~UserInfo()
{

}

UserInfo::UserInfo()
{

}

UserInfo::UserInfo(bool iIsFirstLogin, QString iUserId, QString iConsumerId, QString iPassCode1, QString iPassCode2)
{
    IsFirstLogin_ = iIsFirstLogin;
    UserId_ = iUserId;
    ConsumerId_ = iConsumerId;
    PassCode1_ = iPassCode1;
    PassCode2_ = iPassCode2;
}

UserInfo::UserInfo(const UserInfo& other)
{
    IsFirstLogin_ = other.IsFirstLogin_;
    UserId_ = other.UserId_;
    ConsumerId_ = other.ConsumerId_;
    PassCode1_ = other.PassCode1_;
    PassCode2_ = other.PassCode2_;
}

UserInfo& UserInfo::operator = (const UserInfo& other)
{
    IsFirstLogin_ = other.IsFirstLogin_;
    UserId_ = other.UserId_;
    ConsumerId_ = other.ConsumerId_;
    PassCode1_ = other.PassCode1_;
    PassCode2_ = other.PassCode2_;
    return *this;
}

