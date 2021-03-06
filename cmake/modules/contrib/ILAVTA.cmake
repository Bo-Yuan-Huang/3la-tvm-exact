if(USE_ILAVTA_CODEGEN STREQUAL "ON") 
  include_directories(BEFORE SYSTEM ${VTA_HW_PATH}/include)
  add_definitions(-DUSE_ILAVTA_RUNTIME=1)
  file(GLOB ILAVTA_RELAY_CONTRIB_SRC src/relay/backend/contrib/ilavta/*.cc)
  list(APPEND COMPILER_SRCS ${ILAVTA_RELAY_CONTRIB_SRC})
  list(APPEND COMPILER_SRCS ${JSON_RELAY_CONTRIB_SRC})

  file(GLOB ILAVTA_CONTRIB_SRC src/runtime/contrib/ilavta/ilavta_runtime.cc)
  list(APPEND ILAVTA_CONTRIB_SRC src/runtime/contrib/ilavta/ilavta_helpers.cc)
  file(GLOB VTA_RUNTIME_SRCS ${VTA_HW_PATH}/src/*.cc)
  list(APPEND VTA_RUNTIME_SRCS ${VTA_HW_PATH}/src/sim/sim_driver.cc)
  list(APPEND VTA_RUNTIME_SRCS ${VTA_HW_PATH}/src/sim/sim_tlpp.cc)
  list(APPEND VTA_RUNTIME_SRCS ${VTA_HW_PATH}/src/vmem/virtual_memory.cc)
  
  list(APPEND RUNTIME_SRCS ${ILAVTA_CONTRIB_SRC})
  list(APPEND RUNTIME_SRCS ${VTA_RUNTIME_SRCS})
  
  set(VTA_CONFIG ${PYTHON} ${VTA_HW_PATH}/config/vta_config.py)

  if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/vta_config.json)
    message(STATUS "Use VTA config " ${CMAKE_CURRENT_BINARY_DIR}/vta_config.json)
    set(VTA_CONFIG ${PYTHON} ${VTA_HW_PATH}/config/vta_config.py
      --use-cfg=${CMAKE_CURRENT_BINARY_DIR}/vta_config.json)
  endif()
  execute_process(COMMAND ${VTA_CONFIG} --target OUTPUT_VARIABLE VTA_TARGET OUTPUT_STRIP_TRAILING_WHITESPACE)
  message(STATUS "Build VTA runtime with target: " ${VTA_TARGET})
  execute_process(COMMAND ${VTA_CONFIG} --defs OUTPUT_VARIABLE __vta_defs)
  string(REGEX MATCHALL "(^| )-D[A-Za-z0-9_=.]*" VTA_DEFINITIONS "${__vta_defs}")

  foreach(__def ${VTA_DEFINITIONS})
    string(SUBSTRING ${__def} 3 -1 __strip_def)
    add_definitions(-D${__strip_def})
  endforeach()
endif()
