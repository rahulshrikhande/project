// Generated by Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import CoreGraphics;
@import UIKit;
@import Foundation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
enum MenuPresentMode : NSInteger;
@class UIColor;
@class UISideMenuNavigationController;
@class UIView;
@class UIPanGestureRecognizer;

SWIFT_CLASS("_TtC8SideMenu15SideMenuManager")
@interface SideMenuManager : NSObject
/**
  The presentation mode of the menu.
  There are four modes in MenuPresentMode:
  <ul>
    <li>
      menuSlideIn: Menu slides in over of the existing view.
    </li>
    <li>
      viewSlideOut: The existing view slides out to reveal the menu.
    </li>
    <li>
      viewSlideInOut: The existing view slides out while the menu slides in.
    </li>
    <li>
      menuDissolveIn: The menu dissolves in over the existing view controller.
    </li>
  </ul>
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) enum MenuPresentMode menuPresentMode;)
+ (enum MenuPresentMode)menuPresentMode;
+ (void)setMenuPresentMode:(enum MenuPresentMode)value;
/**
  Prevents the same view controller (or a view controller of the same class) from being pushed more than once. Defaults to true.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL menuAllowPushOfSameClassTwice;)
+ (BOOL)menuAllowPushOfSameClassTwice;
+ (void)setMenuAllowPushOfSameClassTwice:(BOOL)value;
/**
  Pops to any view controller already in the navigation stack instead of the view controller being pushed if they share the same class. Defaults to false.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL menuAllowPopIfPossible;)
+ (BOOL)menuAllowPopIfPossible;
+ (void)setMenuAllowPopIfPossible:(BOOL)value;
/**
  Width of the menu when presented on screen, showing the existing view controller in the remaining space. Default is 75% of the screen width.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) CGFloat menuWidth;)
+ (CGFloat)menuWidth;
+ (void)setMenuWidth:(CGFloat)value;
/**
  Duration of the animation when the menu is presented without gestures. Default is 0.35 seconds.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) double menuAnimationPresentDuration;)
+ (double)menuAnimationPresentDuration;
+ (void)setMenuAnimationPresentDuration:(double)value;
/**
  Duration of the animation when the menu is dismissed without gestures. Default is 0.35 seconds.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) double menuAnimationDismissDuration;)
+ (double)menuAnimationDismissDuration;
+ (void)setMenuAnimationDismissDuration:(double)value;
/**
  Amount to fade the existing view controller when the menu is presented. Default is 0 for no fade. Set to 1 to fade completely.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) CGFloat menuAnimationFadeStrength;)
+ (CGFloat)menuAnimationFadeStrength;
+ (void)setMenuAnimationFadeStrength:(CGFloat)value;
/**
  The amount to scale the existing view controller or the menu view controller depending on the \code
  menuPresentMode
  \endcode. Default is 1 for no scaling. Less than 1 will shrink, greater than 1 will grow.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) CGFloat menuAnimationTransformScaleFactor;)
+ (CGFloat)menuAnimationTransformScaleFactor;
+ (void)setMenuAnimationTransformScaleFactor:(CGFloat)value;
/**
  The background color behind menu animations. Depending on the animation settings this may not be visible. If \code
  menuFadeStatusBar
  \endcode is true, this color is used to fade it. Default is black.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) UIColor * _Nullable menuAnimationBackgroundColor;)
+ (UIColor * _Nullable)menuAnimationBackgroundColor;
+ (void)setMenuAnimationBackgroundColor:(UIColor * _Nullable)value;
/**
  The shadow opacity around the menu view controller or existing view controller depending on the \code
  menuPresentMode
  \endcode. Default is 0.5 for 50% opacity.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) float menuShadowOpacity;)
+ (float)menuShadowOpacity;
+ (void)setMenuShadowOpacity:(float)value;
/**
  The shadow color around the menu view controller or existing view controller depending on the \code
  menuPresentMode
  \endcode. Default is black.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) UIColor * _Nonnull menuShadowColor;)
+ (UIColor * _Nonnull)menuShadowColor;
+ (void)setMenuShadowColor:(UIColor * _Nonnull)value;
/**
  The radius of the shadow around the menu view controller or existing view controller depending on the \code
  menuPresentMode
  \endcode. Default is 5.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) CGFloat menuShadowRadius;)
+ (CGFloat)menuShadowRadius;
+ (void)setMenuShadowRadius:(CGFloat)value;
/**
  The left menu swipe to dismiss gesture.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, weak) UIPanGestureRecognizer * _Nullable menuLeftSwipeToDismissGesture;)
+ (UIPanGestureRecognizer * _Nullable)menuLeftSwipeToDismissGesture;
+ (void)setMenuLeftSwipeToDismissGesture:(UIPanGestureRecognizer * _Nullable)value;
/**
  The right menu swipe to dismiss gesture.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, weak) UIPanGestureRecognizer * _Nullable menuRightSwipeToDismissGesture;)
+ (UIPanGestureRecognizer * _Nullable)menuRightSwipeToDismissGesture;
+ (void)setMenuRightSwipeToDismissGesture:(UIPanGestureRecognizer * _Nullable)value;
/**
  Enable or disable interaction with the presenting view controller while the menu is displayed. Enabling may make it difficult to dismiss the menu or cause exceptions if the user tries to present and already presented menu. Default is false.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL menuPresentingViewControllerUserInteractionEnabled;)
+ (BOOL)menuPresentingViewControllerUserInteractionEnabled;
+ (void)setMenuPresentingViewControllerUserInteractionEnabled:(BOOL)value;
/**
  The strength of the parallax effect on the existing view controller. Does not apply to \code
  menuPresentMode
  \endcode when set to \code
  ViewSlideOut
  \endcode. Default is 0.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) NSInteger menuParallaxStrength;)
+ (NSInteger)menuParallaxStrength;
+ (void)setMenuParallaxStrength:(NSInteger)value;
/**
  Draws the \code
  menuAnimationBackgroundColor
  \endcode behind the status bar. Default is true.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL menuFadeStatusBar;)
+ (BOOL)menuFadeStatusBar;
+ (void)setMenuFadeStatusBar:(BOOL)value;
/**
  When true, pushViewController called within the menu it will push the new view controller inside of the menu. Otherwise, it is pushed on the menu’s presentingViewController. Default is false.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL menuAllowSubmenus;)
+ (BOOL)menuAllowSubmenus;
+ (void)setMenuAllowSubmenus:(BOOL)value;
/**
  When true, pushViewController will replace the last view controller in the navigation controller’s viewController stack instead of appending to it. This makes menus similar to tab bar controller behavior.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL menuReplaceOnPush;)
+ (BOOL)menuReplaceOnPush;
+ (void)setMenuReplaceOnPush:(BOOL)value;
/**
  -Warning: Deprecated. Use \code
  menuAnimationTransformScaleFactor
  \endcode instead.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) CGFloat menuAnimationShrinkStrength;)
+ (CGFloat)menuAnimationShrinkStrength;
+ (void)setMenuAnimationShrinkStrength:(CGFloat)newValue;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
/**
  The left menu.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) UISideMenuNavigationController * _Nullable menuLeftNavigationController;)
+ (UISideMenuNavigationController * _Nullable)menuLeftNavigationController;
+ (void)setMenuLeftNavigationController:(UISideMenuNavigationController * _Nullable)newValue;
/**
  The right menu.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) UISideMenuNavigationController * _Nullable menuRightNavigationController;)
+ (UISideMenuNavigationController * _Nullable)menuRightNavigationController;
+ (void)setMenuRightNavigationController:(UISideMenuNavigationController * _Nullable)newValue;
/**
  Enable or disable gestures that would swipe to present or dismiss the menu. Default is true.
*/
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL menuEnableSwipeGestures;)
+ (BOOL)menuEnableSwipeGestures;
+ (void)setMenuEnableSwipeGestures:(BOOL)newValue;
/**
  Adds a pan edge gesture to a view to present menus.
  \param toView The view to add a pan gesture to.


  returns:
  The pan gesture added to \code
  toView
  \endcode.
*/
+ (UIPanGestureRecognizer * _Nonnull)menuAddPanGestureToPresentToView:(UIView * _Nonnull)toView;
@end

typedef SWIFT_ENUM(NSInteger, MenuPresentMode) {
  MenuPresentModeMenuSlideIn = 0,
  MenuPresentModeViewSlideOut = 1,
  MenuPresentModeViewSlideInOut = 2,
  MenuPresentModeMenuDissolveIn = 3,
};

@protocol UIViewControllerContextTransitioning;
@class UIViewController;
@protocol UIViewControllerInteractiveTransitioning;

SWIFT_CLASS("_TtC8SideMenu18SideMenuTransition")
@interface SideMenuTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (void)animateTransition:(id <UIViewControllerContextTransitioning> _Nonnull)transitionContext;
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> _Nullable)transitionContext;
- (id <UIViewControllerAnimatedTransitioning> _Nullable)animationControllerForPresentedController:(UIViewController * _Nonnull)presented presentingController:(UIViewController * _Nonnull)presenting sourceController:(UIViewController * _Nonnull)source;
- (id <UIViewControllerAnimatedTransitioning> _Nullable)animationControllerForDismissedController:(UIViewController * _Nonnull)dismissed;
- (id <UIViewControllerInteractiveTransitioning> _Nullable)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning> _Nonnull)animator;
- (id <UIViewControllerInteractiveTransitioning> _Nullable)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning> _Nonnull)animator;
@end

@protocol UIViewControllerTransitionCoordinator;
@class UIStoryboardSegue;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC8SideMenu30UISideMenuNavigationController")
@interface UISideMenuNavigationController : UINavigationController
- (void)awakeFromNib;
/**
  Whether the menu appears on the right or left side of the screen. Right is the default.
*/
@property (nonatomic) BOOL leftSide;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator> _Nonnull)coordinator;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (BOOL)shouldPerformSegueWithIdentifier:(NSString * _Nonnull)identifier sender:(id _Nullable)sender;
- (void)pushViewController:(UIViewController * _Nonnull)viewController animated:(BOOL)animated;
- (nonnull instancetype)initWithNavigationBarClass:(Class _Nullable)navigationBarClass toolbarClass:(Class _Nullable)toolbarClass OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithRootViewController:(UIViewController * _Nonnull)rootViewController OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8SideMenu22UITableViewVibrantCell")
@interface UITableViewVibrantCell : UITableViewCell
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)layoutSubviews;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nullable)reuseIdentifier SWIFT_UNAVAILABLE;
@end

#pragma clang diagnostic pop
