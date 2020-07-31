#!/bin/sh

PATH="$PATH:~/Qt/5.12.9/ios/bin"

lupdate -locations absolute ../christmastree.pro -ts ../translations/christmastree_de.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmastree_de.qml.ts

lupdate -locations absolute ../christmastree.pro -ts ../translations/christmastree_es.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmastree_es.qml.ts

lupdate -locations absolute ../christmastree.pro -ts ../translations/christmastree_fr.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmastree_fr.qml.ts

lupdate -locations absolute ../christmastree.pro -ts ../translations/christmastree_it.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmastree_it.qml.ts

lupdate -locations absolute ../christmastree.pro -ts ../translations/christmastree_ru.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmastree_ru.qml.ts

lupdate -locations absolute ../christmastree.pro -ts ../translations/christmastree_zh.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmastree_zh.qml.ts

lconvert ../translations/christmastree_de.src.ts ../translations/christmastree_de.qml.ts -o ../translations/christmastree_de.ts
lconvert ../translations/christmastree_es.src.ts ../translations/christmastree_es.qml.ts -o ../translations/christmastree_es.ts
lconvert ../translations/christmastree_fr.src.ts ../translations/christmastree_fr.qml.ts -o ../translations/christmastree_fr.ts
lconvert ../translations/christmastree_it.src.ts ../translations/christmastree_it.qml.ts -o ../translations/christmastree_it.ts
lconvert ../translations/christmastree_ru.src.ts ../translations/christmastree_ru.qml.ts -o ../translations/christmastree_ru.ts
lconvert ../translations/christmastree_zh.src.ts ../translations/christmastree_zh.qml.ts -o ../translations/christmastree_zh.ts
