Import-Module ActiveDirectory

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$form = New-Object System.Windows.Forms.Form
$form.Text = "Benutzer erstellen"
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = "CenterScreen"


# Vorname
$label1 = New-Object System.Windows.Forms.Label
$label1.Text = "Vorname:"
$label1.Location = New-Object System.Drawing.Point(10,20)

$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Point(120,20)


# Nachname
$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "Nachname:"
$label2.Location = New-Object System.Drawing.Point(10,60)

$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(120,60)


# Gruppe
$label3 = New-Object System.Windows.Forms.Label
$label3.Text = "Gruppen:"
$label3.Location = New-Object System.Drawing.Point(10,100)

$groupList = New-Object System.Windows.Forms.CheckedListBox
$groupList.Location = New-Object System.Drawing.Point(120,100)
$groupList.Size = New-Object System.Drawing.Size(180,120)


# Gruppen aus AD laden
$groups = Get-ADGroup -Filter * -SearchBase "OU=SelectableGroups,DC=fischer,DC=it" |
    Sort-Object Name

foreach ($g in $groups) {
    [void]$groupList.Items.Add($g.Name)
}


$button = New-Object System.Windows.Forms.Button
$button.Text = "Erstellen"
$button.Location = New-Object System.Drawing.Point(120,240)


$script:formClosedNormally = $false


$button.Add_Click({

    if ([string]::IsNullOrWhiteSpace($textBox1.Text) -or
        [string]::IsNullOrWhiteSpace($textBox2.Text)) {

        [System.Windows.Forms.MessageBox]::Show("Bitte Name eingeben!")
        return
    }

    # Namen speichern
    $script:firstName = $textBox1.Text
    $script:lastName = $textBox2.Text

    # Gruppen speichern
    $script:selectedGroups = @()

    foreach ($item in $groupList.CheckedItems) {
        $script:selectedGroups += [string]$item
    }

    $script:formClosedNormally = $true
    $form.Close()
})


$form.Add_FormClosing({

    if (-not $script:formClosedNormally) {
        $script:firstName = $null
        $script:lastName = $null
        $script:selectedGroups = $null
    }

})


$form.Controls.AddRange(@(
    $label1,$textBox1,
    $label2,$textBox2,
    $label3,$groupList,
    $button
))


[void]$form.ShowDialog()


# Abbruch
if (-not $firstName -or -not $lastName) {
    Write-Host "Abgebrochen - kein Benutzer erstellt."
    exit
}


# Username generieren
for ($i = 0; $i -le 999; $i++) {

    $username = "user{0:D3}" -f $i

    $exists = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue

    if (-not $exists) {
        break
    }
}


# Passwort generieren
$words = Get-Content "C:\Scripts\Diceware.txt"

$word1 = Get-Random $words
$word2 = Get-Random $words
$number = Get-Random -Minimum 10 -Maximum 99

$passwordPlain = "$word1!$word2$number"
$passwordSecure = ConvertTo-SecureString $passwordPlain -AsPlainText -Force


# Benutzer erstellen
$fullName = "$firstName $lastName"
$upn = "$username@fischer.it"

New-ADUser `
    -Name $fullName `
    -GivenName $firstName `
    -Surname $lastName `
    -SamAccountName $username `
    -UserPrincipalName $upn `
    -AccountPassword $passwordSecure `
    -Enabled $true `
    -Path "CN=Users,DC=fischer,DC=it" `
    -ChangePasswordAtLogon $false `
    -PasswordNeverExpires $true


# Gruppen zuweisen
foreach ($group in $selectedGroups) {
    Add-ADGroupMember -Identity $group -Members $username
}


# Output
$message = "Benutzer wurde erstellt!`n`n"
$message += "Name: $fullName`n"
$message += "Username: $username`n"
$message += "Passwort: $passwordPlain`n`n"
$message += "Gruppen:`n - " + ($selectedGroups -join "`n - ")

[System.Windows.Forms.MessageBox]::Show($message, "Erfolg")