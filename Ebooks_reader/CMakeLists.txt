cmake_minimum_required(VERSION 3.16)

project(Ebooks_reader VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appEbooks_reader
    main.cpp
)

qt_add_qml_module(appEbooks_reader
    URI Ebooks_reader
    QML_FILES
        Main.qml
        RESOURCES assets/icon-books.svg assets/icon-discover.svg assets/icon-home.svg assets/icon-more.svg
        QML_FILES IconTabButton.qml
        QML_FILES ControlCenter.qml
        RESOURCES assets/icon-battery.svg assets/icon-brightness.svg assets/icon-refresh.svg assets/icon-search.svg assets/icon-wifi.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appEbooks_reader PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appEbooks_reader
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appEbooks_reader
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appEbooks_reader
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
