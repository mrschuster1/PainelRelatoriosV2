object Connection: TConnection
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDConn: TFDConnection
    Params.Strings = (
      'Database=painel'
      'User_Name=root'
      'Password=root'
      'Server=192.168.1.94'
      'DriverID=MySQL'
      'CharacterSet=utf8')
    LoginPrompt = False
    BeforeConnect = FDConnBeforeConnect
    Left = 240
    Top = 216
  end
  object MySQLDriver: TFDPhysMySQLDriverLink
    Left = 392
    Top = 224
  end
end
