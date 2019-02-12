
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
$emsg = $ns + "<br />"
}

}

if($x -gt 0)

{

#Адрес сервера SMTP для отправки
$serverSmtp = "smtp.yandex.ru"

#Порт сервера
$port = 587

#От кого
$From = "login@yandex.ru"

#Кому
$To = "somemail@yandex.ru"

#Тема письма
$subject = "Alert, smth is not working    " + $rptDate

#Логин и пароль от ящики с которого отправляете login@yandex.ru
$user = "login"
$pass = "*****"

#Путь до файла
$file = "C:\FileYouWantToSend.txt"

#Создаем два экземпляра класса
$att = New-object Net.Mail.Attachment($file)
$mes = New-Object System.Net.Mail.MailMessage

#Формируем данные для отправки
$mes.From = $from
$mes.To.Add($to)
$mes.Subject = $subject
$mes.IsBodyHTML = $true
$mes.Body = "<h1>Тестовое письмо c  вложением</h1>"

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
