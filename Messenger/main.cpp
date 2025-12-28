#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "contactsmodel.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    auto* contactsModel = new ContactsModel(&app);
    Q_UNUSED(contactsModel);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Messenger", "Main");

    return app.exec();
}
