FROM texlive/texlive:latest-full

COPY compile-files.sh /compile-files.sh
RUN chmod +x /compile-files.sh

ENTRYPOINT ["bash", "/compile-files.sh"]