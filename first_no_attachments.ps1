
#Сбрасываем служебные переменные
$x = 0
$emsg = ""

#Дата отчета
$rptDate = Get-Date

#Список адресов для пинга
$Devices = "C:\ListAdresses.txt"

#Получаем адреса для пинга в переменную
$networkSystems = Get-Content $Devices

#Пингуем каждый адрес из списка
foreach($ns in $networkSystems)
{
#Если пинг неудачен - добавляем адрес в отчет
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
$pass = "*****"


#Создаем экземпляр класса

$mes = New-Object System.Net.Mail.MailMessage

#Формируем данные для отправки
$mes.From = $from
$mes.To.Add($to) 
$mes.Subject = $subject 
$mes.IsBodyHTML = $true 
$mes.Body = "<h1>Тестовое письмо</h1>" + $emsg


#Создаем экземпляр класса подключения к SMTP серверу 
$smtp = New-Object Net.Mail.SmtpClient($serverSmtp, $port)

#Сервер использует SSL 
$smtp.EnableSSL = $true 

#Создаем экземпляр класса для авторизации на сервере яндекса
$smtp.Credentials = New-Object System.Net.NetworkCredential($user, $pass);

#Отправляем письмо
$smtp.Send($mes) 

}