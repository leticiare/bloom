import logging
import os
from logging.handlers import TimedRotatingFileHandler

import colorlog


class Logger:
    LOG_DIR = "logs"
    LOG_FILE = "app.log"
    LOG_LEVEL_CONSOLE = logging.DEBUG
    LOG_LEVEL_FILE = logging.INFO

    DATE_FORMAT = "%Y-%m-%d %H:%M:%S"
    CONSOLE_FORMAT = "%(log_color)s%(levelname)s%(reset)s:    %(asctime)s - %(message)s"
    FILE_FORMAT = "%(levelname)s:      %(asctime)s - %(message)s"

    LOG_COLORS = {
        "DEBUG": "cyan",
        "INFO": "green",
        "WARNING": "yellow",
        "ERROR": "red",
        "CRITICAL": "bold_red",
    }

    def __init__(self, name: str = "logger"):
        self.name = name
        self.logger = logging.getLogger(self.name)
        self.logger.setLevel(logging.DEBUG)
        self.logger.propagate = False

        os.makedirs(self.LOG_DIR, exist_ok=True)
        self.log_path = os.path.join(self.LOG_DIR, self.LOG_FILE)

        if not self.logger.handlers:
            self._add_console_handler()
            self._add_file_handler()

    def _add_console_handler(self):
        console_handler = logging.StreamHandler()
        console_formatter = colorlog.ColoredFormatter(
            fmt=self.CONSOLE_FORMAT,
            datefmt=self.DATE_FORMAT,
            log_colors=self.LOG_COLORS,
        )
        console_handler.setFormatter(console_formatter)
        console_handler.setLevel(self.LOG_LEVEL_CONSOLE)
        self.logger.addHandler(console_handler)

    def _add_file_handler(self):
        file_handler = TimedRotatingFileHandler(
            self.log_path,
            when="midnight",
            interval=1,
            backupCount=7,
            encoding="utf-8",
        )
        file_formatter = logging.Formatter(
            fmt=self.FILE_FORMAT, datefmt=self.DATE_FORMAT
        )
        file_handler.setFormatter(file_formatter)
        file_handler.setLevel(self.LOG_LEVEL_FILE)
        self.logger.addHandler(file_handler)

    def get_logger(self):
        return self.logger


logger = Logger().get_logger()
