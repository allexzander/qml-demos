cmake_minimum_required(VERSION 3.16)

project(Ebooks_reader VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appEbooks_reader
    main.cpp
)

add_subdirectory(Config)

qt_add_qml_module(appEbooks_reader
    URI Ebooks_reader
    QML_FILES
        Main.qml
        RESOURCES  assets/icon-discover.svg assets/icon-home.svg assets/icon-more.svg
        QML_FILES MainTabsButton.qml
        QML_FILES ControlCenter.qml
        RESOURCES assets/icon-battery.svg assets/icon-books.svg assets/icon-brightness.svg assets/icon-refresh.svg assets/icon-search.svg assets/icon-wifi.svg
        QML_FILES HomePage.qml
        RESOURCES assets/books/book1.jpg assets/books/book2.jpg assets/books/book3.jpg assets/books/book4.jpg
        RESOURCES assets/books/book5.jpg assets/books/book6.jpg assets/books/book7.jpg assets/books/book8.jpg assets/books/book9.jpg assets/books/book10.jpg
        QML_FILES BookStack.qml
        QML_FILES InfoCard.qml
    DEPENDENCIES
        TARGET Config
        QML_FILES DiscoverPage.qml
        RESOURCES
        QML_FILES TabsButton.qml
        RESOURCES
        QML_FILES TabsButton.qml
        QML_FILES ListBooks.qml
        QML_FILES
        QML_FILES DiscoverPageSection.qml
        RESOURCES assets/books/book11.jpg assets/books/book12.jpg assets/books/book13.jpg assets/books/book14.jpg assets/books/book15.jpg assets/books/book16.jpg assets/books/book17.jpg assets/books/book18.jpg assets/books/book19.jpg assets/books/book20.jpg
        SOURCES booksmodel.hpp
        SOURCES booksmodel.cpp
        SOURCES book.hpp
        SOURCES booksproxymodel.hpp
        SOURCES booksproxymodel.cpp
        SOURCES bookenums.hpp
        SOURCES
        QML_FILES BooksPage.qml
        QML_FILES ScrollBarCustom.qml
        QML_FILES ReaderComboBox.qml
        QML_FILES MorePage.qml
        QML_FILES
        RESOURCES assets/loading.gif
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
    PRIVATE Qt6::Quick Configplugin
)

include(GNUInstallDirs)
install(TARGETS appEbooks_reader
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
