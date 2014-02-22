var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

UIALogger.logStart("Logging element tree...");
target.logElementTree();
UIALogger.logPass();

target.pushTimeout(2);
app.navigationBar().buttons()["Add"].tap();
target.popTimeout();

UIALogger.logStart("Logging element tree...");
target.logElementTree();
UIALogger.logPass();

target.pushTimeout(2);
window.toolbar().buttons()["Cancel"].tap();
target.popTimeout();
