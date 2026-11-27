"""Current P0.2 smoke entry point; P0.1 historical test remains at P0.1 commit."""
import pathlib,runpy
runpy.run_path(str(pathlib.Path(__file__).with_name("smoke_p02.py")),run_name="__main__")
