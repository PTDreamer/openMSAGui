QT += charts quick quickcontrols2

TARGET = openMSAGui

OPENMSA_DIR = $$(OPENMSA_DIR)
HEADERS += \
    datasource.h \
    markerx.h \
    markerfactory.h \
    settings.h

SOURCES += \
    main.cpp \
    datasource.cpp \
    markerx.cpp \
    markerfactory.cpp \
    settings.cpp
isEmpty(OPENMSA_DIR) {
SOURCES += ../openMSA/shared/comprotocol.cpp
HEADERS += ../openMSA/shared/comprotocol.h
INCLUDEPATH += ../openMSA/shared
}
else {
message("Using openMSA directory from environment variable")
SOURCES += $$(OPENMSA_DIR)/shared/comprotocol.cpp
HEADERS += $$(OPENMSA_DIR)/shared/comprotocol.h
INCLUDEPATH += $$(OPENMSA_DIR)/shared
}

RESOURCES += \
    icons/icons.qrc \
    qml/qml.qrc \
    imagine-assets/imagine-assets.qrc \
    qtquickcontrols2.conf \

DISTFILES += \
    qml/* \
    qtquickcontrols2.conf \
    uncrustify.cfg

linux-g++ {
message("copying assets to $$OUT_PWD")
copydata.commands = $(COPY) $$PWD/deployment/linux/* $$OUT_PWD
first.depends = $(first) copydata
export(first.depends)
export(copydata.commands)
QMAKE_EXTRA_TARGETS += first copydata
}
