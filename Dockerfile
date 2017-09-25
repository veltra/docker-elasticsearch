FROM elasticsearch:5.5.1
RUN elasticsearch-plugin install analysis-icu
RUN elasticsearch-plugin install analysis-kuromoji
RUN elasticsearch-plugin install org.codelibs:elasticsearch-configsync:5.5.0
