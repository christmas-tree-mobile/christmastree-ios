#!/bin/sh

PATH=$PATH:~/Qt/5.9.1/ios/bin

lupdate ../christmastree.pro -ts ../translations/christmastree_ru.src.ts
lupdate ../qml               -ts ../translations/christmastree_ru.qml.ts

lupdate ../christmastree.pro -ts ../translations/christmastree_de.src.ts
lupdate ../qml               -ts ../translations/christmastree_de.qml.ts

lupdate ../christmastree.pro -ts ../translations/christmastree_fr.src.ts
lupdate ../qml               -ts ../translations/christmastree_fr.qml.ts

lconvert ../translations/christmastree_ru.src.ts ../translations/christmastree_ru.qml.ts -o ../translations/christmastree_ru.ts
lconvert ../translations/christmastree_de.src.ts ../translations/christmastree_de.qml.ts -o ../translations/christmastree_de.ts
lconvert ../translations/christmastree_fr.src.ts ../translations/christmastree_fr.qml.ts -o ../translations/christmastree_fr.ts
