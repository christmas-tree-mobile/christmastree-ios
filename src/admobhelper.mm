#import <UIKit/UIKit.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

#include <QtCore/QtGlobal>
#include <QtCore/QtMath>
#include <QtCore/QLatin1String>
#include <QtCore/QDebug>

#include "admobhelper.h"

const QString AdMobHelper::ADMOB_BANNERVIEW_UNIT_ID  (QStringLiteral("ca-app-pub-2455088855015693/5862941320"));
const QString AdMobHelper::ADMOB_INTERSTITIAL_UNIT_ID(QStringLiteral("ca-app-pub-2455088855015693/4082955796"));
const QString AdMobHelper::ADMOB_TEST_DEVICE_ID      (QLatin1String(""));

namespace {

constexpr NSTimeInterval AD_RELOAD_ON_FAILURE_DELAY = 60.0;

}

@interface BannerViewDelegate : NSObject<GADBannerViewDelegate>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHelper:(AdMobHelper *)helper NS_DESIGNATED_INITIALIZER;
- (void)dealloc;
- (void)cleanupAndAutorelease;
- (void)setPersonalization:(BOOL)personalized;
- (void)loadAd;

@end

@implementation BannerViewDelegate
{
    BOOL           ShowPersonalizedAds;
    GADBannerView *BannerView;
    AdMobHelper   *AdMobHelperInstance;
}

- (instancetype)initWithHelper:(AdMobHelper *)helper
{
    self = [super init];

    if (self != nil) {
        ShowPersonalizedAds = NO;
        AdMobHelperInstance = helper;

        UIViewController * __block root_view_controller = nil;

        [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
            root_view_controller = window.rootViewController;

            *stop = (root_view_controller != nil);
        }];

        BannerView = [[GADBannerView alloc] initWithAdSize:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ?
                                                            kGADAdSizeLeaderboard : kGADAdSizeBanner)];

        BannerView.adUnitID                                  = AdMobHelper::ADMOB_BANNERVIEW_UNIT_ID.toNSString();
        BannerView.autoloadEnabled                           = YES;
        BannerView.translatesAutoresizingMaskIntoConstraints = NO;
        BannerView.rootViewController                        = root_view_controller;
        BannerView.delegate                                  = self;
    }

    return self;
}

- (void)dealloc
{
    BannerView.rootViewController = nil;
    BannerView.delegate           = nil;

    [BannerView removeFromSuperview];
    [BannerView release];

    [super dealloc];
}

- (void)cleanupAndAutorelease
{
    AdMobHelperInstance = nullptr;

    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self autorelease];
}

- (void)setPersonalization:(BOOL)personalized
{
    ShowPersonalizedAds = personalized;
}

- (void)loadAd
{
    GADRequest *request = [GADRequest request];

    if (!ShowPersonalizedAds) {
        GADExtras *extras = [[[GADExtras alloc] init] autorelease];

        extras.additionalParameters = @{@"npa": @"1"};

        [request registerAdNetworkExtras:extras];
    }

    [BannerView loadRequest:request];
}

- (void)bannerViewDidReceiveAd:(nonnull GADBannerView *)bannerView
{
    Q_UNUSED(bannerView)

    UIViewController * __block root_view_controller = nil;

    [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
        root_view_controller = window.rootViewController;

        *stop = (root_view_controller != nil);
    }];

    [root_view_controller.view addSubview:BannerView];

    UILayoutGuide *guide = root_view_controller.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        [BannerView.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor],
        [BannerView.topAnchor     constraintEqualToAnchor:guide.topAnchor]
    ]];

    CGSize  status_bar_size   = UIApplication.sharedApplication.statusBarFrame.size;
    CGFloat status_bar_height = qMin(status_bar_size.width, status_bar_size.height);

    if (AdMobHelperInstance != nullptr) {
        AdMobHelperInstance->SetBannerViewHeight(qFloor(BannerView.frame.size.height + root_view_controller.view.safeAreaInsets.top
                                                                                     - status_bar_height));
    }
}

- (void)bannerView:(nonnull GADBannerView *)bannerView didFailToReceiveAdWithError:(nonnull NSError *)error
{
    Q_UNUSED(bannerView)

    qWarning() << QString::fromNSString(error.localizedDescription);

    [self performSelector:@selector(loadAd) withObject:nil afterDelay:AD_RELOAD_ON_FAILURE_DELAY];
}

@end

@interface InterstitialDelegate : NSObject<GADFullScreenContentDelegate>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHelper:(AdMobHelper *)helper NS_DESIGNATED_INITIALIZER;
- (void)dealloc;
- (void)cleanupAndAutorelease;
- (void)setPersonalization:(BOOL)personalized;
- (void)loadAd;
- (void)show;
- (BOOL)isReady;

@end

@implementation InterstitialDelegate
{
    BOOL               ShowPersonalizedAds;
    GADInterstitialAd *Interstitial;
    AdMobHelper       *AdMobHelperInstance;
}

- (instancetype)initWithHelper:(AdMobHelper *)helper
{
    self = [super init];

    if (self != nil) {
        ShowPersonalizedAds = NO;
        AdMobHelperInstance = helper;

        [self performSelector:@selector(loadAd) withObject:nil afterDelay:0.0];
    }

    return self;
}

- (void)dealloc
{
    Interstitial.fullScreenContentDelegate = nil;

    [Interstitial release];

    [super dealloc];
}

- (void)cleanupAndAutorelease
{
    AdMobHelperInstance = nullptr;

    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self autorelease];
}

- (void)setPersonalization:(BOOL)personalized
{
    ShowPersonalizedAds = personalized;
}

- (void)loadAd
{
    Interstitial.fullScreenContentDelegate = nil;

    [Interstitial release];

    Interstitial = nil;

    GADRequest *request = [GADRequest request];

    if (!ShowPersonalizedAds) {
        GADExtras *extras = [[[GADExtras alloc] init] autorelease];

        extras.additionalParameters = @{@"npa": @"1"};

        [request registerAdNetworkExtras:extras];
    }

    [GADInterstitialAd loadWithAdUnitID:AdMobHelper::ADMOB_INTERSTITIAL_UNIT_ID.toNSString() request:request
                       completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error != nil) {
            qWarning() << QString::fromNSString(error.localizedDescription);

            [self performSelector:@selector(loadAd) withObject:nil afterDelay:AD_RELOAD_ON_FAILURE_DELAY];
        } else {
            Interstitial = [ad retain];

            Interstitial.fullScreenContentDelegate = self;
        }
    }];
}

- (void)show
{
    if (Interstitial != nil) {
        UIViewController * __block root_view_controller = nil;

        [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
            root_view_controller = window.rootViewController;

            *stop = (root_view_controller != nil);
        }];

        [Interstitial presentFromRootViewController:root_view_controller];
    }
}

- (BOOL)isReady
{
    if (Interstitial != nil) {
        return YES;
    } else {
        return NO;
    }
}

- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad
{
    Q_UNUSED(ad)

    if (AdMobHelperInstance != nullptr) {
        AdMobHelperInstance->SetInterstitialActive(true);
    }
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad
{
    Q_UNUSED(ad)

    if (AdMobHelperInstance != nullptr) {
        AdMobHelperInstance->SetInterstitialActive(false);
    }

    [self performSelector:@selector(loadAd) withObject:nil afterDelay:0.0];
}

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error
{
    Q_UNUSED(ad)

    qWarning() << QString::fromNSString(error.localizedDescription);
}

@end

AdMobHelper::AdMobHelper(QObject *parent) :
    QObject                     (parent),
    Initialized                 (false),
    ShowPersonalizedAds         (false),
    InterstitialActive          (false),
    BannerViewHeight            (0),
    BannerViewDelegateInstance  (nil),
    InterstitialDelegateInstance(nil)
{
}

AdMobHelper::~AdMobHelper() noexcept
{
    [BannerViewDelegateInstance   cleanupAndAutorelease];
    [InterstitialDelegateInstance cleanupAndAutorelease];
}

AdMobHelper &AdMobHelper::GetInstance()
{
    static AdMobHelper instance;

    return instance;
}

bool AdMobHelper::interstitialReady() const
{
    if (Initialized) {
        return [InterstitialDelegateInstance isReady];
    } else {
        return false;
    }
}

bool AdMobHelper::interstitialActive() const
{
    return InterstitialActive;
}

int AdMobHelper::bannerViewHeight() const
{
    return BannerViewHeight;
}

void AdMobHelper::initAds()
{
    if (!Initialized) {
        [GADMobileAds sharedInstance].requestConfiguration.maxAdContentRating = GADMaxAdContentRatingGeneral;

        if (AdMobHelper::ADMOB_TEST_DEVICE_ID != QLatin1String("")) {
            [GADMobileAds sharedInstance].requestConfiguration.testDeviceIdentifiers = @[AdMobHelper::ADMOB_TEST_DEVICE_ID.toNSString()];
        }

        [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];

        InterstitialDelegateInstance = [[InterstitialDelegate alloc] initWithHelper:this];

        [InterstitialDelegateInstance setPersonalization:ShowPersonalizedAds];
        [InterstitialDelegateInstance loadAd];

        Initialized = true;
    }
}

void AdMobHelper::setPersonalization(bool personalized)
{
    ShowPersonalizedAds = personalized;

    if (Initialized) {
        [BannerViewDelegateInstance   setPersonalization:ShowPersonalizedAds];
        [InterstitialDelegateInstance setPersonalization:ShowPersonalizedAds];
    }
}

void AdMobHelper::showBannerView()
{
    if (Initialized) {
        [BannerViewDelegateInstance cleanupAndAutorelease];

        if (BannerViewHeight != 0) {
            BannerViewHeight = 0;

            emit bannerViewHeightChanged(BannerViewHeight);
        }

        BannerViewDelegateInstance = [[BannerViewDelegate alloc] initWithHelper:this];

        [BannerViewDelegateInstance setPersonalization:ShowPersonalizedAds];
        [BannerViewDelegateInstance loadAd];
    }
}

void AdMobHelper::hideBannerView()
{
    if (Initialized) {
        [BannerViewDelegateInstance cleanupAndAutorelease];

        if (BannerViewHeight != 0) {
            BannerViewHeight = 0;

            emit bannerViewHeightChanged(BannerViewHeight);
        }

        BannerViewDelegateInstance = nil;
    }
}

void AdMobHelper::showInterstitial() const
{
    if (Initialized) {
        [InterstitialDelegateInstance show];
    }
}

void AdMobHelper::SetInterstitialActive(bool active)
{
    if (InterstitialActive != active) {
        InterstitialActive = active;

        emit interstitialActiveChanged(InterstitialActive);
    }
}

void AdMobHelper::SetBannerViewHeight(int height)
{
    if (BannerViewHeight != height) {
        BannerViewHeight = height;

        emit bannerViewHeightChanged(BannerViewHeight);
    }
}
