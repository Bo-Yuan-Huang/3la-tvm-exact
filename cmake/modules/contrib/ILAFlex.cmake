if(USE_ILAFLEX_CODEGEN STREQUAL "ON") 
  add_definitions(-DUSE_ILAFLEX_RUNTIME=1)
  file(GLOB ILAFLEX_RELAY_CONTRIB_SRC src/relay/backend/contrib/ilaflex/*.cc)
  list(APPEND COMPILER_SRCS ${ILAFLEX_RELAY_CONTRIB_SRC})
  list(APPEND COMPILER_SRCS ${JSON_RELAY_CONTRIB_SRC})

  file(GLOB ILAFLEX_CONTRIB_SRC src/runtime/contrib/ilaflex/ilaflex_runtime.cc)
  list(APPEND RUNTIME_SRCS ${ILAFLEX_CONTRIB_SRC})
endif()
