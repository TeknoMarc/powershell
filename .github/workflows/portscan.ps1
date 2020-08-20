Set-ExecutionPolicy Bypass -Scope Process -Force;

Function Scan ($StartAddress, $LastAddress) {

	$ErrorActionPreference= 'SilentlyContinue'
	$SplitStart = $StartAddress.split(".")
	$SplitStop = $LastAddress.split(".")
	
    $Start = $SplitStart[2] -as [int]
    $Stop = $SplitStop[2] -as [int]

    $ports =  20, 21, 22, 23, 25, 50, 51, 53, 67, 68, 69, 80, 110, 119, 123, 135, 136, 137, 138, 139, 143, 161, 162, 389, 443, 3389

    $range = $Start..$Stop
    
    $3rdoctet = $SplitStart[2] -as [int]    
    $4thoctet = $SplitStart[3] -as [int]

    Do{
        
            ForEach($number in $range){
            
            $SplitStart[2] = $number

            For($octet=1; $octet -lt 255; $octet++){
            $SplitStart[3] = $octet
            $CurrentAddress = $SplitStart -join "."
                If(Test-Connection -BufferSize 32 -Count 1 -Quiet -ComputerName $CurrentAddress){
                
                Write-Host "Host Found $CurrentAddress"
                
                ForEach($port in $ports){
                    $socket = new-object System.Net.Sockets.TcpClient([IPAddress]$CurrentAddress, $port)
                    If($socket.Connected){ "$CurrentAddress port $port open" } $socket.Close()
                
                }    
            
                }
            
            }
            
            }
    } Until ($CurrentAddress -eq $LastAddress)
}

Scan "10.1.248.1" "10.1.251.254"
