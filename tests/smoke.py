"""Current P0.7 smoke entry point."""
import pathlib,runpy
runpy.run_path(str(pathlib.Path(__file__).with_name("smoke_p07.py")),run_name="__main__")
