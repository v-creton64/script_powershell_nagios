if (($args[0]-eq $null)-or($args[1]-eq $null)){
    $WARNING=25
    $CRITICAL=35
}else {
    $WARNING = $args[0]
    $CRITICAL = $args[1]
}
if ($WARNING -ge $CRITICAL){
    Write-Output "UNKNOWN: La valeur de WARNING est superieur/egale a la valeur de CRITICAL"
    exit 3
}

#Recuperation du nombre d'utilisateurs
$userCount = (query user).count -1

#Vérification du nombre d'utilisateur
if ($userCount -gt $CRITICAL) {
    Write-Output "CRITICAL: Nombre d'utilisateurs trop eleve ($userCount)"
    exit 2
} elseif ($userCount -gt $WARNING) {
    Write-Output "WARNING: Nombre d'utilisateurs eleve ($userCount)"
    exit 1
} elseif ($userCount -le 0) {
    Write-Output "OK: Aucun utilisateurs ($userCount)"
    exit 0    
} else {
    Write-Output "OK: Nombre d'utilisateurs normal ($userCount)"
    exit 0
}