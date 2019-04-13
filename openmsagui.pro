QT += charts quick quickcontrols2

HEADERS += \
    datasource.h \
    ../openmsa/shared/comprotocol.h \
    markerx.h \
    markerfactory.h

SOURCES += \
    main.cpp \
    datasource.cpp \
    ../openmsa/shared/comprotocol.cpp \
    markerx.cpp \
    markerfactory.cpp

RESOURCES += \
    icons/icons.qrc \
    qml/qml.qrc \
    imagine-assets/imagine-assets.qrc \
    qtquickcontrols2.conf \

DISTFILES += \
    qml/* \
    qtquickcontrols2.conf \
    uncrustify.cfg

target.path = /home/jose/Desktop/qmloscilloscope
INSTALLS += target
