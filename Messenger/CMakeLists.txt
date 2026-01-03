cmake_minimum_required(VERSION 3.16)

project(Messenger VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appMessenger
    main.cpp
)

qt_add_qml_module(appMessenger
    URI Messenger
    VERSION 1.0

    QML_FILES
        "Main.qml"
        "UserAvatar.qml"
        "conversations/AppHeader.qml"
        "conversations/Conversations.qml"
        "conversations/ConversationListItem.qml"
        "conversations/SearchBar.qml"
        "conversationdetails/ConversationDetails.qml"
        "conversationdetails/ConversationMessageListItem.qml"
        "conversationdetails/ConversationWorkspace.qml"
        "conversationdetails/MessageComposer.qml"

    RESOURCES
        "assets/current_user_photo.jpg"
        "assets/icons/icon-call.svg"
        "assets/icons/icon-like.svg"
        "assets/icons/icon-menu.svg"
        "assets/icons/icon-plus.svg"
        "assets/icons/icon-search.svg"
        "assets/icons/icon-smile.svg"
        "assets/icons/icon-sticker.svg"
        "assets/icons/icon-videocall.svg"
        "assets/icons/icon-write.svg"
        "assets/icons/new-message-icon.svg"

        "assets/user_photos/user_photo_2.jpg"
        "assets/user_photos/user_photo_3.jpg"
        "assets/user_photos/user_photo_4.jpg"
        "assets/user_photos/user_photo_5.jpg"
        "assets/user_photos/user_photo_6.jpg"
        "assets/user_photos/user_photo_7.jpg"
        "assets/user_photos/user_photo_8.jpg"
        "assets/user_photos/user_photo_9.jpg"
        "assets/user_photos/user_photo_10.jpg"
        "assets/user_photos/user_photo_11.jpg"
        "assets/user_photos/user_photo_12.jpg"

    SOURCES
        contactsmodel.hpp
        contactsmodel.cpp
        conversationsmodel.hpp
        conversationsmodel.cpp
        messagesmodel.hpp
        messagesmodel.cpp
        datatypes.hpp

    DEPENDENCIES
        TARGET Config
        RESOURCES assets/user_photos/user_photo_1.jpg
)

add_subdirectory(Config)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMessenger PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMessenger
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMessenger
    PRIVATE Qt6::Quick
    Configplugin
)

include(GNUInstallDirs)
install(TARGETS appMessenger
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
