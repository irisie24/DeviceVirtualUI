#ifndef APPLICATION_THEME
#define APPLICATION_THEME

#include <cstdint>
#include <QObject>
#include <QString>
#include <QGuiApplication>
#include <QScreen>

class ApplicationTheme
{
    Q_GADGET

public:
    // ---- Mode -------------------------------------------------------------
    bool IsDarkMode_ = true;

    // ---- Surfaces ---------------------------------------------------------
    QString BaseColor_;             // absolute black / white
    QString PanelLowerColor_;       // frames holding large groups of widgets
    QString PanelUpperColor_;       // smaller panels sitting inside a lower panel
    QString LineColor_;             // borders, separators, scrollbars

    // ---- Widget states ----------------------------------------------------
    QString WidgetPassiveColor_;
    QString WidgetPassiveHoverColor_;
    QString WidgetActiveColor_;
    QString WidgetPressedColor_;
    QString WidgetActiveTextColor_; // label colour sitting on the active fill

    // ---- Accent variants (progress bars, dials) ---------------------------
    QString AccentBaseColor_;
    QString AccentHighlightColor_;

    // ---- Text -------------------------------------------------------------
    QString TextPrimaryColor_;
    QString TextSecondaryColor_;
    QString TextDisabledColor_;

    // ---- Feedback ---------------------------------------------------------
    QString FocusRingColor_;
    QString SuccessColor_;
    QString WarningColor_;
    QString ErrorColor_;
    QString InfoColor_;

    // ---- Dimensions (derived from primary screen height) ------------------
    uint32_t BarHeight_ = 0;
    uint32_t SideMenuExpandedWidth_ = 0;
    uint32_t SideMenuCollapsedWidth_ = 0;

    Q_PROPERTY(bool IsDarkMode MEMBER IsDarkMode_)

    Q_PROPERTY(QString BaseColor MEMBER BaseColor_)
    Q_PROPERTY(QString PanelLowerColor MEMBER PanelLowerColor_)
    Q_PROPERTY(QString PanelUpperColor MEMBER PanelUpperColor_)
    Q_PROPERTY(QString LineColor MEMBER LineColor_)

    Q_PROPERTY(QString WidgetPassiveColor MEMBER WidgetPassiveColor_)
    Q_PROPERTY(QString WidgetPassiveHoverColor MEMBER WidgetPassiveHoverColor_)
    Q_PROPERTY(QString WidgetActiveColor MEMBER WidgetActiveColor_)
    Q_PROPERTY(QString WidgetPressedColor MEMBER WidgetPressedColor_)
    Q_PROPERTY(QString WidgetActiveTextColor MEMBER WidgetActiveTextColor_)

    Q_PROPERTY(QString AccentBaseColor MEMBER AccentBaseColor_)
    Q_PROPERTY(QString AccentHighlightColor MEMBER AccentHighlightColor_)

    Q_PROPERTY(QString TextPrimaryColor MEMBER TextPrimaryColor_)
    Q_PROPERTY(QString TextSecondaryColor MEMBER TextSecondaryColor_)
    Q_PROPERTY(QString TextDisabledColor MEMBER TextDisabledColor_)

    Q_PROPERTY(QString FocusRingColor MEMBER FocusRingColor_)
    Q_PROPERTY(QString SuccessColor MEMBER SuccessColor_)
    Q_PROPERTY(QString WarningColor MEMBER WarningColor_)
    Q_PROPERTY(QString ErrorColor MEMBER ErrorColor_)
    Q_PROPERTY(QString InfoColor MEMBER InfoColor_)

    Q_PROPERTY(uint32_t BarHeight MEMBER BarHeight_)
    Q_PROPERTY(uint32_t SideMenuExpandedWidth MEMBER SideMenuExpandedWidth_)
    Q_PROPERTY(uint32_t SideMenuCollapsedWidth MEMBER SideMenuCollapsedWidth_)

public:
    ApplicationTheme() { EnableDarkMode(); }
    ~ApplicationTheme() = default;
    ApplicationTheme(const ApplicationTheme&) = default;
    ApplicationTheme& operator=(const ApplicationTheme&) = default;

    void EnableDarkMode()
    {
        IsDarkMode_ = true;

        BaseColor_               = "#000000";
        PanelLowerColor_         = "#0E1116";
        PanelUpperColor_         = "#1A1F27";
        LineColor_               = "#3A424F";

        WidgetPassiveColor_      = "#2A313C";
        WidgetPassiveHoverColor_ = "#353D4A";
        WidgetActiveColor_       = "#38A3FF";
        WidgetPressedColor_      = "#1F7FD1";
        WidgetActiveTextColor_   = "#00121F";

        AccentBaseColor_         = "#9932cc";
        AccentHighlightColor_    = "#fff0f5";

        TextPrimaryColor_        = "#E6EAF0";
        TextSecondaryColor_      = "#98A2B3";
        TextDisabledColor_       = "#566070";

        FocusRingColor_          = "#7CC4FF";
        SuccessColor_            = "#3FB950";
        WarningColor_            = "#E3A008";
        ErrorColor_              = "#F85149";
        InfoColor_               = "#58A6FF";

        UpdateDimensions();
    }

    void EnableLightMode()
    {
        IsDarkMode_ = false;

        BaseColor_               = "#FFFFFF";
        PanelLowerColor_         = "#F1F3F6";
        PanelUpperColor_         = "#E4E8EE";
        LineColor_               = "#B4BCC9";

        WidgetPassiveColor_      = "#D3D9E2";
        WidgetPassiveHoverColor_ = "#C6CDD8";
        WidgetActiveColor_       = "#0B6BCB";
        WidgetPressedColor_      = "#0A57A6";
        WidgetActiveTextColor_   = "#FFFFFF";

        AccentBaseColor_         = "#9932cc";
        AccentHighlightColor_    = "#fff0f5";

        TextPrimaryColor_        = "#12161C";
        TextSecondaryColor_      = "#4B5563";
        TextDisabledColor_       = "#9AA3AF";

        FocusRingColor_          = "#0B6BCB";
        SuccessColor_            = "#1A7F37";
        WarningColor_            = "#B45309";
        ErrorColor_              = "#C62828";
        InfoColor_               = "#0969DA";

        UpdateDimensions();
    }

    void UpdateDimensions()
    {
        const QScreen* s = QGuiApplication::primaryScreen();
        if (!s)
            return; // keep previous values; screen not available yet

        const qreal sh = s->geometry().height();
        BarHeight_              = static_cast<uint32_t>(sh * 0.045);
        SideMenuExpandedWidth_  = static_cast<uint32_t>(sh * 0.180);
        SideMenuCollapsedWidth_ = static_cast<uint32_t>(sh * 0.045);
    }
};

#endif