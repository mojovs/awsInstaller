#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QtWebEngine/QtWebEngine>
#include "DownloadObj.h"
#include "ProcObj.h"
#include "FuncModel.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    //初始化web
    QtWebEngine::initialize();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject *obj, const QUrl &objUrl)
        {
            if (!obj && url == objUrl) QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    //创建属性
    QQmlContext *ctx = engine.rootContext();
    ctx->setContextProperty("downloader", new DownloadObj);
    ctx->setContextProperty("proc", new ProcObj);
    ctx->setContextProperty("listModel", new FuncModel);
    //设置一个当前程序路径
    ctx->setContextProperty("curDirPath", QString(QDir::currentPath()));
    //导入main.qml
    engine.load(url);
    return app.exec();
}
