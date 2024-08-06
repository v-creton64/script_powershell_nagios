#Vérification de la presence du nom de la collection RDS
if ($args[0] -eq $null) {
    Write-Output "UNKNOWN: Il manque le nom de la collection RDS"
    exit 3
} else {
    $COLLECTION = $args[0]
}

#Vérification de l'existance de la collection
try {
    Get-RDSessionHost -CollectionName $COLLECTION -ErrorAction Stop > $null
}
catch{
    Write-Output "UNKNOWN: IL n'y a pas de collection RDS a ce nom"
    exit 3
}

#Vérification de la présence d'argument pour le warning et critical
if (($args[1]-eq $null)-or($args[2]-eq $null)){
    $WARNING=1
    $CRITICAL=2
}else {
    $WARNING = $args[1]
    $CRITICAL = $args[2]
}

#Recuperation du nombre de serveur en maintenance
$MAINTENANCE = (Get-RDSessionHost -CollectionName $COLLECTION | Where-Object {$_.NewConnectionAllowed -eq "NO"}).count
#Recuperation de la liste des serveurs en maintenance
$LISTE = Get-RDSessionHost -CollectionName $COLLECTION | Where-Object {$_.NewConnectionAllowed -eq "NO"} | Select-Object SessionHost

#Test et code retour 
if ($MAINTENANCE -ge $CRITICAL) {
    Write-Output "CRITICAL: Il y a $MAINTENANCE serveurs en maintenance"
    Write-Output $LISTE
    exit 2
} elseif ($MAINTENANCE -ge $WARNING) {
    Write-Output "WARNING: Il y a $MAINTENANCE serveur en maintenance"
    Write-Output $LISTE
    exit 1
} else {
    Write-Output "OK: Il n'y a aucun serveur en maintenance"
    exit 0   
}