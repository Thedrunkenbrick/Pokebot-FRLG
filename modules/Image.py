import cv2
import logging

from modules.mmf.Emu import GetEmu
from modules.mmf.Screenshot import GetScreenshot

log = logging.getLogger(__name__)


def DetectTemplate(file: str):
    """
    Return true if template (image) is found anywhere on-screen
    :param file: File location of image to search
    :return: Boolean value of whether image was found
    """
    try:
        if any([x in GetEmu()["detectedGame"] for x in ["Emerald"]]):  # "Ruby", "Sapphire"
            vers = "RSE"
        elif any([x in GetEmu()["detectedGame"] for x in ["FireRed", "LeafGreen"]]):
            vers = "FRLG"
        threshold = 0.999
        template = cv2.imread(f"./modules/data/templates/{vers}/{GetEmu()['language']}/" + file, cv2.IMREAD_UNCHANGED)
        # hh, ww = template.shape[:2]

        screenshot = GetScreenshot()
        correlation = cv2.matchTemplate(screenshot, template[:, :, 0:3],
                                        cv2.TM_CCORR_NORMED)  # Do masked template matching and save correlation image
        min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(correlation)
        max_val_corr = float('{:.6f}'.format(max_val))
        if max_val_corr > threshold:
            # Debug image detection - shows a window with a red square around the detected match
            # loc = numpy.where(correlation >= threshold)
            # result = screenshot.copy()
            # for point in zip(*loc[::-1]):
            #    cv2.rectangle(result, point, (point[0]+ww, point[1]+hh), (0,0,255), 1)
            #    cv2.imshow(f"match", result)
            #    cv2.waitKey(1)
            return True
        else:
            return False

    except Exception as e:
        log.debug(str(e))
        return False
