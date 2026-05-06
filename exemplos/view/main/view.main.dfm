object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Painel - Relat'#243'rios'
  ClientHeight = 669
  ClientWidth = 1024
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI Semibold'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  FormStyle = fsMDIForm
  Position = poOwnerFormCenter
  RoundedCorners = rcOn
  OnClose = dxFluentDesignFormClose
  OnCreate = dxFluentDesignFormCreate
  NavigationControl = dxNavBar1
  TextHeight = 15
  object dxNavBar1: TdxNavBar
    Left = 0
    Top = 0
    Width = 210
    Height = 669
    Align = alLeft
    ActiveGroupIndex = 0
    TabOrder = 0
    View = 21
    OptionsBehavior.Common.AllowExpandAnimation = True
    OptionsView.HamburgerMenu.NavigationPaneMode = npmNone
    object dxNavBar1Group1: TdxNavBarGroup
      Caption = 'Atendimentos'
      SelectedLinkIndex = -1
      TopVisibleLinkIndex = 0
      Links = <
        item
          Item = dxNavBar1Item1
        end>
    end
    object dxNavBar1Item1: TdxNavBarItem
      Caption = 'Geral'
      OnClick = dxNavBar1Item1Click
    end
  end
  object SkinController: TdxSkinController
    NativeStyle = False
    ScrollbarMode = sbmHybrid
    ScrollMode = scmSmooth
    SkinName = 'WXI'
    FormCorners = fcRounded
    SkinPaletteName = 'Clearness'
    ShowFormShadow = bTrue
    Left = 576
    Top = 312
  end
  object LayoutLookAndFeelList: TdxLayoutLookAndFeelList
    Left = 576
    Top = 240
    object dxLayoutSkinLookAndFeel1: TdxLayoutSkinLookAndFeel
      PixelsPerInch = 96
    end
  end
  object TabbedMDIManager: TdxTabbedMDIManager
    Active = True
    TabProperties.AllowTabDragDrop = True
    TabProperties.CloseButtonMode = cbmActiveAndHoverTabs
    TabProperties.CloseTabWithMiddleClick = True
    TabProperties.CustomButtons.Buttons = <>
    TabProperties.HotTrack = True
    TabProperties.Options = [pcoAlwaysShowGoDialogButton, pcoGradient, pcoGradientClientArea, pcoRedrawOnResize, pcoUsePageColorForTab]
    TabProperties.ShowButtonHints = True
    TabProperties.ShowTabHints = True
    TabProperties.Style = 11
    TabProperties.TabCaptionAlignment = taLeftJustify
    Left = 536
    Top = 400
    PixelsPerInch = 96
  end
  object Idioma: TcxLocalizer
    Left = 504
    Top = 344
  end
end
