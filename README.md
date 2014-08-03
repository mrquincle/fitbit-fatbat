# FitBit

The FitBit you can buy everywhere nowadays. However, regretfully they closed the protocol for outsiders. Thankfully I live in Holland where figuring out how a device works for purposes of interfacing with it, is one of my rights. :-) Complaints can be send to the Dutch government. Of course, I hope more people are gonna buy the FitBit if I manage to open it to the general public, just as happened with the Kinect which is used by many roboticists now over the entire world. Interesting by the way to read up on that story. The guy behind it, [Johnny Chung Lee](http://procrastineering.blogspot.nl/2011/02/windows-drivers-for-kinect.html), ran the Adafruit OpenKinect contest as a covert operation (the hack was a joke).

My background is robotics, embedded programming, wireless sensor networks. At the startup [DoBots](http://dobots.nl) we are working on very cheap Bluetooth Low-Energy solutions for home automation for example. I am not gonna tell how I reverse engineer things, but you can assume it is always quite simple. Just reading log files, BLE sniffing, dumping `/proc/kcore`, perhaps JTAG so now and then, but that's seldomly necessary. :-) As [Theodore Watson](http://www.nytimes.com/2012/06/03/magazine/how-kinect-spawned-a-commercial-ecosystem.html?pagewanted=all) describes it, I am not a hacker, I'm just a tinkerer.

## Resources

* [Kyle Machulis (openyou)](https://github.com/openyou/libfitbit) has the code to transfer data from the old versions of the FitBit, which was ANT based, the Ultra. All the current trackers, the One, the Zip, the Flex, and the Force use BLE and are encrypted (partly).
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

Here `1522 242F 1507` is my device id. The value `6B02` and `7002` is a counter expressing the total number of bytes communication back and forth between my laptop and the Fitbit.

The `MICRO_DUMP` has a different opcode:

    3002 0000 0100 5302 0000 1522 242F 1507

Last 4 bytes seem to denote the size (big-endian).

During a connecting there are packets sent at regular intervals (every minute so it seems by default). This packet is built up like this:

    02 0C 20 17 00 13 00 04 00 | 1B 11 00

The `02` here means that it is an ACL data packet type, part of Bluetooth HCI. The ACL packet comes with a connection handle `0C`. The following two bytes `17 00` stands for the total data length, 23 in decimal notation. The bytes `13 00` indicates the length of the L2CAP part of the packet. And `04 00` indicates the attribute protocol. The byte `01` is a "handle value notification" opcode, and `11 00` for the handle itself. After this header follows the data itself:

    02 0C 20 17 00 13 00 04 00 | 1B 11 00 || F0 F2 D7 53 | 21 01 00 00 | 7C 67 03 00 | 4B 06 00 00

The data `F0 F2 D7 53` is in big-endian notation 0x53D7F2F0 = 1406661360 and is a timestamp. The next four bytes `0x00000121` stand for 289 steps, the next four `0x0003677C` stands for 223100 as a distance (0.2231 km). The next byte `0x4B` is a counter and probably this is true for the last four bytes as a whole. So, this was easy. :-) Note, that to get this type of data you first are required to go through an authentication procedure, so you can't just run `hcitool -le*` and expect everything to be done.



## Encryption

The good thing is that the data is now encrypted. The bad thing is that FitBit did not send everybody the encryption key to get to their own data. For example, it is not possible to see the number of steps you take of your own BLE device that your proudly build using a nRF51822 chip from Nordic. Pity!

## NFC

The NFC chip in the Fitbit Flex, is from NXP Semiconductors. The IC is type NTAG203(F) and is a Type 2 Tag. It has a text record #1 which is the device id, but it in a different order than the `28 02` messages, the text is `07 15 22 24 2F 15` instead of `15 22 24 2F 15 07`. It must be tough for them to maintain all those inconsistencies! There is also an [Android Application record](https://developer.android.com/guide/topics/connectivity/nfc/nfc.html), this opens up the Fitbit Mobile app when in proximity to the tag (which for me only worked after installing the FitTap app as well. Apart from the ID the NFC chip does not contain much interesting information.

## Copyrights

The FitBit name is property of that company. 

* Author: Anne van Rossum
* License: LGPLv3, get the License text yourself, please
* Copyrights: Me
* Date: July, 2014

Please, fork and submit issues.
