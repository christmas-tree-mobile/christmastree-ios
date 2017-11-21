import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.LocalStorage 2.0
import QtPurchasing 1.0

import "Core"

import "BuildSettings.js" as BuildSettingsScript

Window {
    id:         mainWindow
    visibility: Window.FullScreen
    visible:    true

    property bool fullVersion:    false
    property bool versionForKids: BuildSettingsScript.VERSION_FOR_KIDS

    onFullVersionChanged: {
        setSetting("FullVersion", fullVersion ? "true" : "false");

        if (mainStackView.depth > 0 && mainStackView.currentItem.hasOwnProperty("bannerViewHeight")) {
            if (fullVersion) {
                AdMobHelper.hideBannerView();
            } else {
                AdMobHelper.showBannerView();
            }
        }
    }

    function setSetting(key, value) {
        var db = LocalStorage.openDatabaseSync("ChristmasTreeDB", "1.0", "ChristmasTreeDB", 1000000);

        db.transaction(
                    function(tx) {
                        tx.executeSql("REPLACE INTO SETTINGS (KEY, VALUE) VALUES (?, ?)", [key, value]);
                    }
        );
    }

    function getSetting(key, defaultValue) {
        var value = defaultValue;
        var db    = LocalStorage.openDatabaseSync("ChristmasTreeDB", "1.0", "ChristmasTreeDB", 1000000);

        db.transaction(
                    function(tx) {
                        tx.executeSql("CREATE TABLE IF NOT EXISTS SETTINGS(KEY TEXT PRIMARY KEY, VALUE TEXT)");

                        var res = tx.executeSql("SELECT VALUE FROM SETTINGS WHERE KEY=?", [key]);

                        if (res.rows.length !== 0) {
                            value = res.rows.item(0).VALUE;
                        }
                    }
        );

        return value;
    }

    function purchaseFullVersion() {
        fullVersionProduct.purchase();
    }

    function restorePurchases() {
        store.restorePurchases();
    }

    Store {
        id: store

        Product {
            id:         fullVersionProduct
            identifier: "christmastree.version.full"
            type:       Product.Unlockable

            onPurchaseSucceeded: {
                mainWindow.fullVersion = true;

                transaction.finalize();
            }

            onPurchaseRestored: {
                mainWindow.fullVersion = true;

                transaction.finalize();
            }

            onPurchaseFailed: {
                if (transaction.failureReason === Transaction.ErrorOccurred) {
                    console.log(transaction.errorString);
                }

                transaction.finalize();
            }
        }
    }

    StackView {
        id:           mainStackView
        anchors.fill: parent

        onCurrentItemChanged: {
            for (var i = 0; i < depth; i++) {
                var item = get(i, false);

                if (item !== null) {
                    item.focus = false;

                    if (item.hasOwnProperty("pageActive")) {
                        item.pageActive = false;
                    }
                }
            }

            if (depth > 0) {
                currentItem.forceActiveFocus();

                if (currentItem.hasOwnProperty("pageActive")) {
                    currentItem.pageActive = true;
                }

                if (currentItem.hasOwnProperty("bannerViewHeight")) {
                    if (mainWindow.fullVersion) {
                        AdMobHelper.hideBannerView();
                    } else {
                        AdMobHelper.showBannerView();
                    }
                } else {
                    AdMobHelper.hideBannerView();
                }
            }
        }
    }

    TreePage {
        id: treePage
    }

    MouseArea {
        id:           screenLockMouseArea
        anchors.fill: parent
        z:            100
        enabled:      mainStackView.busy
    }

    Component.onCompleted: {
        if (BuildSettingsScript.VERSION_FOR_KIDS) {
            fullVersion = true;
        } else {
            fullVersion = (getSetting("FullVersion", "false") === "true");
        }

        AdMobHelper.initialize();

        mainStackView.push(treePage);
    }
}
