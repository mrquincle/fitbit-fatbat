# FitBit

The FitBit you can buy everywhere nowadays. However, regretfully they closed the protocol for outsiders. Thankfully I live in Holland where figuring out how a device works for purposes of interfacing with it, is one of my rights. :-) Complaints can be send to the Dutch government. Of course, I hope more people are gonna buy the FitBit if I manage to open it to the general public, just as happened with the Kinect which is used by many roboticists now over the entire world. Interesting by the way to read up on that story. The guy behind it, [Johnny Chung Lee](http://procrastineering.blogspot.nl/2011/02/windows-drivers-for-kinect.html), ran the Adafruit OpenKinect contest as a covert operation (the hack was a joke).

My background is robotics, embedded programming, wireless sensor networks. At the startup [DoBots](http://dobots.nl) we are working on very cheap Bluetooth Low-Energy solutions for home automation for example. I am not gonna tell how I reverse engineer things, but you can assume it is always quite simple. Just reading log files, BLE sniffing, dumping `/proc/kcore`, perhaps JTAG so now and then, but that's seldomly necessary. :-) As [Theodore Watson](http://www.nytimes.com/2012/06/03/magazine/how-kinect-spawned-a-commercial-ecosystem.html?pagewanted=all) describes it, I am not a hacker, I'm just a tinkerer.

## Resources

* [openyou](https://github.com/openyou/libfitbit) has the code to transfer data from the old versions of the FitBit, which was ANT based, the Ultra. All the current trackers, the One, the Zip, the Flex, and the Force use BLE and are encrypted (partly).
* [Benoît Allard](https://bitbucket.org/benallard/galileo) uses the USB log files of the dongle given with the FitBit on a Windows machine to understand some information. He uses the sources from [sansneural](https://docs.google.com/file/d/0BwJmJQV9_KRcSE0ySGxkbG1PbVE/edit) for example to know enough to be able to send the `MEGA_DUMP` packet to the FitBit server. 
* [Chris Wade](https://github.com/cmwdotme/fitbitfun) tells he can pair, send commands and receive data, but if this is only [see code](https://github.com/cmwdotme/fitbitfun/blob/master/FitbitTestApp/FitbitDevice.m) triggering a micro-dump, an authentication request, then this is quite useless.

## Encoding

The data is encoded with different opcodes as also described by [Benoît Allard](https://bitbucket.org/benallard/galileo/wiki/Communicationprotocol). The data packets of 20 bytes are SLIP encoded as also explained by him. All control packets start with `0xC0`, so if you have a data packet that starts with `0xC0` it is mapped to a two-byte code `0xDB 0xDC`. And this of course also means that `0xDB` needs to be remapped, namely to `0xDB 0xDD`.

The `MEGA_DUMP` packet is of the form (see [Google doc](https://docs.google.com/file/d/0BwJmJQV9_KRcSE0ySGxkbG1PbVE/edit)):

    2802 0000 0100 1502 0000 68FD 9E2C 0F07
    ...

The dumps I get I am not placing online yet. I don't trust the encryption, so I don't want you to see that I am obese. :-D However, the header is similar:

    2802 0000 0100 6B02 0000 1522 242F 1507
    ...
    # next packet
    2802 0000 0100 7002 0000 1522 242F 1507
    ...

The `MICRO_DUMP` has a different opcode:

    3002 0000 0100 5302 0000 1522 242F 1507

Last 4 bytes seem to denote the size (big-endian).

## Encryption

The good thing is that the data is now encrypted. The bad thing is that FitBit did not send everybody the encryption key to get to their own data. For example, it is not possible to see the number of steps you take of your own BLE device that your proudly build using a nRF51822 chip from Nordic. Pity!

## Copyrights

The FitBit name is property of that company. 

* Author: Anne van Rossum
* License: LGPLv3, get the License text yourself, please
* Copyrights: Me
* Date: July, 2014

Please, fork and submit issues.
