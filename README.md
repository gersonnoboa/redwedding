# Red Wedding
iOS application that stores a phrase securely in the iOS keychain. 
The phrase can be decrypted either by typing a password (in case biometrics 
are disabled), or by retrieving the the encrypted password in the Secure 
Enclave (through biometrics). Supports iOS 11+ and dark mode.

It uses [Clean Swift](https://clean-swift.com/) architecture.

## Installation
Open `RedWedding.xcworkspace` and run. This app was tested mostly on device, 
as it is easier to test FaceID on a device.

## Libraries used
* Cocoapods
* RNCryptor

## Name explanation
The [Red Wedding](https://gameofthrones.fandom.com/wiki/Red_Wedding) is one
of the most important events in the TV show Game of Thrones. Although a lot
of people was involved in its execution, none of the characters (or the viewer) 
were aware that something was being planned. I adopted the name because
of the secrecy that occurred around the events, and this app deals with
encrypting information that is supposed to be secret and accessible only by
the interested party (the final user).