#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Plot foorprint of specified variable from FLEXPART output grid NetCDF file.

Usage example:

  plot_flexpart.py grid.nc NO2 RUN_NAME

where the first argument is the name of the NetCDF file to read, the second
argument is the name of the variable to plot, and the third argument is the
run name used for the output file name.

For each output height in the file, a footprint plot will be created, which
sums all the values in the file.

Plot will be created in the current working directory ...
"""

# standard library imports:
import os
import sys
import time
# the rest of the third party bits:
import matplotlib.pyplot as plt
from cartopy.mpl.ticker import LongitudeFormatter, LatitudeFormatter
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import iris
import numpy as np

# check iris major version:
IRIS_VERSION = int(iris.__version__.split('.')[0])

# when using iris version < 2 (or thereabouts), this helps avoid some
# warnings:
if IRIS_VERSION < 2:
    iris.FUTURE.netcdf_promote = True
    iris.FUTURE.netcdf_no_unlimited = True

def get_args(args_in):
    """
    check input arguments and return values if all looks o.k. ...
    """
    # check length of arguments:
    if len(args_in) != 4:
        # get name of the executable:
        self_name = os.path.basename(args_in[0])
        # print error and exit:
        sys.stderr.write('usage: {0} NC_FILE VAR_NAME RUN_NAME\n'.format(self_name))
        sys.exit()
    # get values:
    nc_file = args_in[1]
    var_name = args_in[2]
    run_name = args_in[3]
    # return values:
    return nc_file, var_name, run_name

def main():
    """
    main function for creating plots
    """

    # check / get args:
    nc_file, var_name, run_name = get_args(sys.argv)

    # load netcdf data using iris:
    fp_cube = iris.load_cube(nc_file, var_name)

    # get lat and lon coordinates:
    lat_coord = fp_cube.coord('grid_latitude')
    lon_coord = fp_cube.coord('grid_longitude')

    # get lat and lon values:
    lat_vals = lat_coord.points
    lon_vals = lon_coord.points

    # get min and max of lat and lon values for plotting:
    lat_min = int(np.ceil(lat_vals.min()))
    lat_max = int(np.floor(lat_vals.max()))
    lon_min = int(np.ceil(lon_vals.min()))
    lon_max = int(np.floor(lon_vals.max()))

    # get height values from data:
    height_coord = fp_cube.coord('height')
    height_vals = height_coord.points

    # define color bounds as values between 0 -> 100:
    col_bounds = [0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 5, 10, 25, 50, 100]
    # create a color map for these values, based on the number of values:
    col_map = [plt.cm.jet((i / len(col_bounds)))
               for i in range(len(col_bounds))]

    # loop through heights:
    for h in enumerate(height_vals):

        # get index and value:
        h_index = h[0]
        h_val = h[1]

        # print height value:
        print('# ', h_val, 'm:')

        # get previous height:
        if h_index == 0:
            h_prev = 0
        else:
            h_prev = height_vals[h_index - 1]
        h_prev_int = int(round(h_prev))

        # height as integer:
        h_int = int(round(h_val))
        # get a cube for this height:
        ta = time.time()
        h_cube = fp_cube[0, 0, :, h_index]
        tb = time.time()
        print('load data : ', (tb - ta) / 60, ' minutes')

        # sum the values:
        ta = time.time()
        sum_cube = h_cube.collapsed('time', iris.analysis.SUM)
        tb = time.time()
        print('sum : ', (tb - ta) / 60, ' minutes')
        # mask any 0 values:
        ta = time.time()
        sum_cube_mask = np.ones(sum_cube.shape)
        sum_cube_mask[sum_cube.data > 0] = 0
        sum_cube.data = np.ma.array(sum_cube.data)
        sum_cube.data.mask = sum_cube_mask
        tb = time.time()
        print('mask : ', (tb - ta) / 60, ' minutes')

        # get max value of data for this height:
        ta = time.time()
        sum_max = np.nanmax(sum_cube.data)
        # convert data to percent of max value:
        sum_cube.data = (sum_cube.data / sum_max) * 100
        tb = time.time()
        print('normalise : ', (tb - ta) / 60, ' minutes')

        # interpolate to 0.2 degrees to avoid mega slow contourf plotting ... :
        ta = time.time()
        interp_points = [('grid_longitude', np.arange(-180, 180, .2)),
                         ('grid_latitude',  np.arange(-90, 90, .2))]
        sum_cube = sum_cube.interpolate(interp_points, iris.analysis.Linear())
        interp_lats = sum_cube.coord('grid_latitude').points
        interp_lons = sum_cube.coord('grid_longitude').points
        tb = time.time()
        print('interpolate : ', (tb - ta) / 60, ' minutes')

        # get start and end times for this run:
        ta = time.time()
        fp_time = fp_cube.coord('time')
        fp_cube_dt_start = fp_time.units.num2date(fp_time.points)[0]
        fp_cube_dt_end = fp_time.units.num2date(fp_time.points)[-1]
        title_time_start = fp_cube_dt_start.strftime('%Y-%m-%d %H:%M')
        title_time_end = fp_cube_dt_end.strftime('%Y-%m-%d %H:%M')
        tb = time.time()
        print('get dates : ', (tb - ta) / 60, ' minutes')

        # set the dpi, width and height for the plot:
        ta = time.time()
        plt_dpi = 300
        plt_w = 3000
        plt_h = 750

        # projection for the plot:
        map_x_offset = -51
        map_crs = ccrs.PlateCarree
        map_prj = map_crs(central_longitude=map_x_offset)

        # create a figure or required size:
        map_fig = plt.figure(figsize=(plt_w / plt_dpi, plt_h / plt_dpi),
                             dpi=plt_dpi)
        # create axes:
        map_ax = plt.axes(projection=map_prj)

        # set plot axes limits:
        map_ax.set_ylim(bottom=lat_min, top=lat_max)
        map_ax.set_xlim(left=lon_min, right=lon_max)

        # set x ticks and y ticks:
        map_ax.set_xticks([-160, -40, 80],
                          crs=map_crs())
        map_ax.set_yticks(range(20, lat_max, 30), crs=map_crs())
        # format x ticks and y ticks:
        lon_formatter = LongitudeFormatter(number_format='.1f',
                                           degree_symbol='')
        lat_formatter = LatitudeFormatter(number_format='.1f',
                                          degree_symbol='')
        map_ax.xaxis.set_major_formatter(lon_formatter)
        map_ax.yaxis.set_major_formatter(lat_formatter)

        # add features to plot:
        map_ax.add_feature(cfeature.LAND)
        map_ax.add_feature(cfeature.OCEAN)
        map_ax.add_feature(cfeature.COASTLINE)
        tb = time.time()
        print('plot setup : ', (tb - ta) / 60, ' minutes')

        # create a contour plot:
        ta = time.time()
        contour_plot = plt.contourf(interp_lons - map_x_offset, interp_lats,
                                    sum_cube.data, col_bounds, colors=col_map,
                                    vmin=0, vmax=100, zorder=10, alpha=0.9,
                                    extend='min')
        tb = time.time()
        print('contourf : ', (tb - ta) / 60, ' minutes')

        # set color limits:
        ta = time.time()
        plt.clim(0, 100)
        # add color bar:
        plt.colorbar(contour_plot, ax=map_ax, shrink=0.7)

        # limit map extent:
        map_ax.set_extent([-180, 180, 5, 85], crs=ccrs.PlateCarree())

        # set the plot title:
        plt_title = '{:,}m - {:,}m\n{} - {}'.format(h_prev_int, h_int,
                                                    title_time_start,
                                                    title_time_end)
        map_ax.set_title(plt_title)
        tb = time.time()
        print('plot config : ', (tb - ta) / 60, ' minutes')

        # save output file:
        ta = time.time()
        plt_fname = '{}m-{}.png'.format(h_int, run_name)
        plt.savefig(plt_fname, dpi=plt_dpi, format='png')

        # close all open plots:
        plt.close('all')
        tb = time.time()
        print('plot save : ', (tb - ta) / 60, ' minutes')

if __name__ == '__main__':
    main()
