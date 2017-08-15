with import <nixpkgs> {};

vim_configurable.customize {
    name = "vim";

    vimrcConfig.customRC = ''
        filetype indent plugin on
        syntax enable
        set wildmode=longest,list
        set wildmenu
        set backspace=indent,eol,start
        set hlsearch
        set number
        set autoread
        set t_Co=256
        set iskeyword-=_

        " Indent
        set shiftwidth=4
        set softtabstop=4
        set expandtab

        set cursorline

        " Code folding
        set foldmethod=indent
        set foldnestmax=1
        set foldlevel=1

        " Ctags
        set tags=./tags

        " Save file with sudo
        cmap w!! w !sudo tee > /dev/null %

        " Spell checker
        command Spell setlocal spell spelllang=en_us

        " File specific commands
        autocmd FileType html setlocal shiftwidth=2 tabstop=2
        autocmd FileType css setlocal shiftwidth=2 tabstop=2
        autocmd BufRead,BufNewFile *.ino  set filetype=c
        autocmd BufRead,BufNewFile *.pde  set filetype=c
    '';

    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
    vimrcConfig.vam.pluginDictionaries = [
        { names = [
            "Syntastic"
            "youcompleteme"
            "rust-vim"
            "vim-nix"
        ]; }
    ];
    vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
        start = [youcompleteme syntastic];
    };
}
