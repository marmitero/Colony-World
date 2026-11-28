"""Current P0.3 smoke entry point; P0.1 historical test remains at P0.1 commit."""
import pathlib,runpy
runpy.run_path(str(pathlib.Path(__file__).with_name("smoke_p03.py")),run_name="__main__")
