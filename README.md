# Haskell School of Music

#### !Work in Progress! Environment setup, exercise solutions and examples for the book "Haskell School of Music: From Signals to Symphonies" by Paul Hudak and Donya Quick.

## Background and Initial Impression

I have purchased this book recently. It's a really challenging, fun and rewarding read and it's exciting to learn Haskell and Euterpea, yet I had some trouble setting up the environment and wrapping my head around some of the examples. This repo is a log of my activity around the book.

First thing to note is that even after you manage to setup the environment correctly and `import Euterpea` in your Haskell program, the `play $ c 4 qn` example in the [Euterpea website](http://euterpea.com/) will **not** synthesize sound or play a sample, but it will send a MIDI signal to your computer's default MIDI output. So be prepared to do some basic MIDI setup to get some sound out of it.

You can find environment setup info below, and the exercise solutions and chapter notes in the corresponding folders.

## Environment Setup on Mac OS X

_Tested on Catalina 10.15.5._

1. Install `ghcup` using the Terminal app following the directives at the [ghcup page](https://www.haskell.org/ghcup/). Interactive installer will take you through the necessary steps to install `ghcup`, `ghc`, `cabal` and the [Haskell Language Server](https://github.com/haskell/haskell-language-server). I typed `YES` for all prompts to install all components, **except the last step**.

    1. Last step of the installer caused a syntax error in my shell profile (the files `.bash_profile` my home directory). So I recommend you to refuse the step with the following prompt:

        ```
        Detected bash shell on your system...
        If you want ghcup to automatically add the required PATH variable to "/Users/kukabi/.bashrc"
        answer with YES, otherwise with NO and press ENTER.
        ```

    2. Instead, append the following line to `~/.bash_profile` so that `ghc`, `ghcup` and `cabal` executables are included in your `PATH`:

        ```bash
        export PATH="$HOME/.local/bin:$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"`
        ```

2. It turned out that Euterpea doesn't support `ghc` versions above 8.6.5, so run the following command to install 8.6.5:

    `ghcup install ghc 8.6.5`

3. And make 8.6.5 the default version:

    `ghcup set ghc 8.6.5`

4. Install [Euterpea](https://github.com/Euterpea/Euterpea) (notice we're not using the default install command, but `cabal v1-install`):

    `cabal v1-install Euterpea`

5. Install [HSoM](https://github.com/Euterpea/HSoM), the library to accompany the book:

    `cabal v1-install HSoM`

6. At this moment you should be able `import Euterpea` in your Haskell programs and run them. Try this code, which will send a C4 quarter note to computer's default MIDI output:

    ```
    user@users-MacBook-Pro:~$ ghci
    GHCi, version 8.6.5: http://www.haskell.org/ghc/ :? for help Loaded package environment from /Users/user/.ghc/x86_64-darwin-8.6.5/environments/default
    Prelude> import Euterpea
    Prelude Euterpea> play $ c 4 qn
    ```

7. Or you can have your program in a Haskell source code file, say `Main.hs`, and compile it with the command `ghc -o Main Main.hs`. Then you should be able to run the compiled executable with the command `./Main`.

    ```haskell
    module Main where

    import Euterpea

    main = play $ c 4 qn
    ```

8. **OPTIONAL** You can also use [stack](https://docs.haskellstack.org/en/stable/README/), a tool to create, build, test and run Haskell projects. It also manages the dependency packages. I personally like it and find it easy to build and run my projects with it. You can install it following the directions in the `stack` [README file](https://docs.haskellstack.org/en/stable/README/).

    1. Create a new project with the command `stack new euterpea-stack-example`. You can find the example project in the root folder of this repository.

    2. Edit `package.yaml` in the project directory and add Euterpea as a dependency:

        ```yaml
        dependencies:
            - base >= 4.7 && < 5
            - Euterpea
        ```

    3. **IMPORTANT** Edit `stack.yaml` and set the following option to make `stack` use the `ghc` that we already have installed:

        ```yaml
        system-ghc: true
        ```

    4. Edit `stack.yaml` and set the `resolver` to `lts-14.27` (corresponds to GHC 8.6.5):

        ```yaml
        resolver: lts-14.27
        ```

    5. Include the other required dependencies also in `stack.yaml`:

        ```yaml
        extra-deps:
            - Euterpea-2.0.7
            - PortMidi-0.2.0.0
            - arrows-0.4.4.2
            - Stream-0.4.7.2
            - lazysmallcheck-0.6
        ```

    6. Now run `stack build` in the root folder of the project. First build is going to take a while as `stack` downloads the dependencies.

    7. You can edit the application code at `app/Main.hs` and run the application by running `stack run` in the project folder.

9. 🎉 Done. You have completed the environment setup, and now you can use Euterpea in your Haskell programs and run them in three different ways:

    1. Through the command line interface `ghci`.

    2. By compiling your Haskell file with `ghc`.

    3. By using `stack` to create, configure, build and run a new Haskell project.
