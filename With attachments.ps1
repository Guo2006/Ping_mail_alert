


#Variable for System Count
$x = 0
$emsg = ""

#Report Date
$rptDate = Get-Date

#Device List Location
$Devices = "C:\Users\aiponevin\Documents\keePass\KeePass-1.36\Devices.txt"

#Load Array of Computer Systems
$networkSystems = Get-Content $Devices

#Ping Each System in Array
foreach($ns in $networkSystems)
{
#If Ping Fails then Add to Message
if (!(test-connection -computername $ns -quiet))
{
$x = $x + 1
$emsg = $emsg + $ns + "<br />"
}

}

if($x -gt 0)

{
$serverSmtp = "smtp.yandex.ru" 

#Порт сервера
$port = 587

#От кого
$From = "login@yandex.ru" 

#Кому
$To = "login@yandex.ru" 

#Тема письма
$subject = "Alert, smth is not working"

#Логин и пароль от ящики с которого отправляете login@yandex.ru
$user = "login"
$pass = "password"

#Путь до файла 
$file = "C:\File.txt"

#Создаем два экземпляра класса
$att = New-object Net.Mail.Attachment($file)
$mes = New-Object System.Net.Mail.MailMessage

#Формируем данные для отправки
$mes.From = $from
$mes.To.Add($to) 
$mes.Subject = $subject 
$mes.IsBodyHTML = $true 
$mes.Body = "<h1>Тестовое письмо</h1>" + $emsg

#Добавляем файл
$mes.Attachments.Add($att) 

#Создаем экземпляр класса подключения к SMTP серверу 
$smtp = New-Object Net.Mail.SmtpClient($serverSmtp, $port)

#Сервер использует SSL 
$smtp.EnableSSL = $true 

#Создаем экземпляр класса для авторизации на сервере яндекса
$smtp.Credentials = New-Object System.Net.NetworkCredential($user, $pass);

#Отправляем письмо, освобождаем память
$smtp.Send($mes) 
$att.Dispose()

}