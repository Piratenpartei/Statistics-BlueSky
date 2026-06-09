[Hashtable]$ToDo = @{
    'de.csv' = 'piratenpartei.de'
    'de-bw.csv' = 'piratenpartei-bw.de'
    'de-by.csv' = 'piratenbayern.bsky.social'
    'de-hb.csv' = 'piratenbremen.bsky.social'
    'de-hh.csv' = 'piraten.hamburg'
    'de-he.csv' = 'piratenhessen.bsky.social'
    'de-mv.csv' = 'piratenpartei-mv.bsky.social'
    'de-nw.csv' = 'piraten.nrw'
    'de-rp.csv' = 'piratenrlp.bsky.social'
    'de-sl.csv' = 'piratensaarland.bsky.social'
    'ag-gesundheit.csv' = 'gesundheitspiraten.de'
    'ag-energiepolitik.csv' = 'aenergiepolitik.bsky.social'
    'ag-piratinnennetzwerk.csv' = 'piratinnennetzwerk.bsky.social'
    }
#    'de-be.csv' = ''
#    'de-bb.csv' = ''
#    'de-ni.csv' = ''
#    'de-sn.csv' = ''
#    'de-st.csv' = ''
#    'de-sh.csv' = ''
#    'de-th.csv' = ''

Connect-BlueSky | Out-Null

$ToDo.keys | foreach-object {
    $File = $_
    $Actor = $ToDo.$File

    $ActorStats = Get-BskyActorProfile -Actor $Actor

    $followersCount = $ActorStats.followersCount
    $postsCount = $ActorStats.postsCount
    
    Get-Date -Format "yyyyMMdd," | Out-File -FilePath ('.' + [IO.Path]::DirectorySeparatorChar + 'data' + [IO.Path]::DirectorySeparatorChar + 'followers_' + $File) -Encoding ascii -Append -NoNewline -Force
    $followersCount | Out-File -FilePath ('.' + [IO.Path]::DirectorySeparatorChar + 'data' + [IO.Path]::DirectorySeparatorChar + 'followers_' + $File) -Encoding ascii -Append -Force

    Get-Date -Format "yyyyMMdd," | Out-File -FilePath ('.' + [IO.Path]::DirectorySeparatorChar + 'data' + [IO.Path]::DirectorySeparatorChar + 'posts_' + $File) -Encoding ascii -Append -NoNewline -Force
    $postsCount | Out-File -FilePath ('.' + [IO.Path]::DirectorySeparatorChar + 'data' + [IO.Path]::DirectorySeparatorChar + 'posts_' + $File) -Encoding ascii -Append -Force
    }
