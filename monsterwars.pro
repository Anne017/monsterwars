# specify the manifest file, this file is required for click
# packaging and for the IDE to create runconfigurations
UBUNTU_MANIFEST_FILE=manifest.json.in

# specify translation domain, this must be equal with the
# app name in the manifest file
UBUNTU_TRANSLATION_DOMAIN="monsterwars.t-mon"

# specify the source files that should be included into
# the translation file, from those files a translation
# template is created in po/template.pot, to create a
# translation copy the template to e.g. de.po and edit the sources
UBUNTU_TRANSLATION_SOURCES+= \
    $$files(ui/*.qml,true)

# specifies all translations files and makes sure they are
# compiled and installed into the right place in the click package
UBUNTU_PO_FILES+=$$files(po/*.po)

TEMPLATE = app
TARGET = MonsterWars

load(ubuntu-click)

QT += qml quick

HEADERS +=  attack.h \
            attackpillow.h \
            backend.h \
            board.h \
            gameengine.h \
            level.h \
            player.h \
            monster.h \
            #pathfinder.h \
            #node.h \
    attackpillowmodel.h

SOURCES +=  main.cpp \
            attack.cpp \
            attackpillow.cpp \
            backend.cpp \
            board.cpp \
            gameengine.cpp \
            level.cpp \
            player.cpp \
            monster.cpp \
            #pathfinder.cpp \
            #node.cpp \
    attackpillowmodel.cpp


RESOURCES += ui.qrc \
             monsters.qrc

OTHER_FILES += MonsterWars.apparmor \
               MonsterWars.desktop \
               MonsterWars.png


# specify where the config files are installed to
config_files.path = /MonsterWars
config_files.files += $${OTHER_FILES}

# install level files
levels.path = /
levels.files = levels/

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS += target config_files levels

