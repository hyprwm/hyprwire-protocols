cmake_minimum_required(VERSION 3.20)

file(STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/VERSION" HYPRWIRE_PROTOCOLS_VERSION
     LIMIT_COUNT 1)
string(STRIP "${HYPRWIRE_PROTOCOLS_VERSION}" HYPRWIRE_PROTOCOLS_VERSION)

project(
  hyprwire-protocols
  VERSION ${HYPRWIRE_PROTOCOLS_VERSION}
  LANGUAGES NONE)

include(GNUInstallDirs)

set(PROTOCOL_FILES protocols/hyprtavern/hp_hyprtavern_core_v1.xml)

foreach(PROTOCOL_FILE ${PROTOCOL_FILES})
  get_filename_component(PROTOCOL_DIR ${PROTOCOL_FILE} DIRECTORY)
  install(
    FILES ${PROTOCOL_FILE}
    DESTINATION "${CMAKE_INSTALL_DATADIR}/hyprwire-protocols/${PROTOCOL_DIR}")
endforeach()

# Configure pkg-config file
set(prefix "${CMAKE_INSTALL_PREFIX}")
set(datarootdir "\${prefix}/${CMAKE_INSTALL_DATADIR}")
set(abs_top_srcdir "${CMAKE_CURRENT_SOURCE_DIR}")
set(PACKAGE "hyprwire-protocols")

configure_file(hyprwire-protocols.pc.in hyprwire-protocols.pc @ONLY)

# Install pkg-config file
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/hyprwire-protocols.pc"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/pkgconfig")
