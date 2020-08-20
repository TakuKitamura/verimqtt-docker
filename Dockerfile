FROM alpine:3.12.0
LABEL maintainer="TakuKitamura <takukitamura.io@gmail.com>" \
      updatedAt="最終動作確認: 2019年 10月 3日 木曜日 14時23分49秒 JST"
ENV FSTAR_HOME="/root/fstar" \
    KREMLIN_HOME="/root/kremlin" \
    LANG="ja_JP.UTF-8"
RUN set -x && \
    echo "Start!" && \
    echo "It takes about 30 minutes." && \
    cd ~ && \
    apk update  && \
    apk add --no-cache bash vim git make ocaml opam m4 wget curl clang gmp-dev perl musl-dev && \
    apk upgrade && \
    # bash && \
    # locale-gen ja_JP.UTF-8 && \
    opam init -y --disable-sandboxing && \
    opam switch create 4.10.0 && \
    eval $(opam env) && \
    opam install depext -y && \
    eval $(opam env) && \
    opam depext conf-gmp.1 -y && \
    eval $(opam env) && \
    opam install ppx_deriving_yojson zarith pprint menhir sedlex process fix wasm visitors stdint num batteries ulex -y && \
    eval $(opam env) && \
    wget https://github.com/FStarLang/binaries/raw/master/z3-tested/z3-4.8.5-x64-ubuntu-16.04.zip && \
    unzip z3-4.8.5-x64-ubuntu-16.04.zip && \
    rm -rf z3-4.8.5-x64-ubuntu-16.04.zip && \
    ln -s /root/z3-4.8.5-x64-ubuntu-16.04/bin/z3 /usr/local/bin/ && \
    git clone https://github.com/FStarLang/FStar.git fstar && \
    cd fstar && \
    git checkout ad3db6d329118416eb51a2902c7874f1783a36cd && \
    make && \
    cd .. && \
    ln -s /root/fstar/bin/fstar.exe /usr/local/bin/ && \
    git clone https://github.com/FStarLang/kremlin.git && \
    cd kremlin && \
    git checkout 2f84363322ac9cf3e1ac8275303faf568a41b88b && \
    make && \
    cd .. && \
    ln -s /root/kremlin/krml /usr/local/bin/ && \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    echo -e "call plug#begin()\nPlug 'TakuKitamura/fstar-kremlin-playground.vim'\ncall plug#end()" > ~/.vimrc && \
    vim -c PlugInstall -c q -c q && \
    git clone https://github.com/TakuKitamura/Fstar-Tutorial.git fstar-tutorial && \
    git clone https://github.com/TakuKitamura/verimqtt.git && \
    cd verimqtt && \
    git checkout dev && \
    cd .. && \
    echo '$(opam config env)' >> ~/.bashrc && \
    source ~/.bashrc && \
    wget https://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz && \
    tar -xzvf afl-latest.tgz && \
    cd afl-2.52b && \
    make && \
    cd .. && \
    rm afl-latest.tgz && \
    echo "Done!" && \
    exec $SHELL -l
