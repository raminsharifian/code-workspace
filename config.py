import os


def init_conf():
    # Ignore initialization
    if os.name != "posix":
        return

    print("Hi linux/unix!...")


if __name__ == "__main__":
    init_conf()
