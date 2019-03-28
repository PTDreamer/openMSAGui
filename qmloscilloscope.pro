QT += charts quick quickcontrols2

HEADERS += \
    datasource.h

SOURCES += \
    main.cpp \
    datasource.cpp

RESOURCES += \
    icons/icons.qrc \
    qml/qml.qrc \
    imagine-assets/imagine-assets.qrc \
    qtquickcontrols2.conf \

DISTFILES += \
    qml/* \
    qtquickcontrols2.conf

target.path = /home/jose/Desktop/qmloscilloscope
INSTALLS += target
