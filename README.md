[![Gem Version](https://badge.fury.io/rb/vkpd.png)](http://badge.fury.io/rb/vkpd)

    vkpd [options] [search request]

#Requirements

vkpd requires mpc to work and sinatra to authenticate

#Options

    -c, --count=n
         Limit songs count
    -o, --offset=n
         Drop first n results
    -s, --sort=n
         Sort by: 0 - popularity, 1 - length, 2 - upload date
    -nf, --no-fix, --exact
         Do not try to fix typos
    user [user_id]
         Load user songs. If user_id not supplied use current user's id
    group <group_id>
         Load group songs
    add
         Add songs to current playlist instead of replacing it

#Some examples
    vkpd Beatles # replaces current mpd playlist with The Beatles' songs and starts playing
    vkpd play Beatles # the same
    vkpd add Beatles # adds found songs to playlist and starts playing
    vkpd -c 5 Beatles # get just first five search results
    vkpd -c 5 -o 5 beatles # get second five results
    vkpd --count 5 --offset=5 beatles # the same
    vkpd user 3885655 # plays user's songs
    vkpd user 3885655 -c 3 # plays last three songs added by user
    vkpd user # current user's songs
    vkpd user -c 1 # current user's last added song
    vkpd group 1 # plays songs from group with id = 1
    vkpd --no-fix Beetles # prevents from searching for Beatles
    vkpd -nf Beetles # same as above
    vkpd -s 1 Beatles # sorted by length. 0 to sort by popularity, 2 to sort by upload date
