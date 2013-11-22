/* See LICENSE file for copyright and license details. */

#include <caml/mlvalues.h>
#include <caml/custom.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#define FG(dc, col)  ((col)[(dc)->invert ? ColBG : ColFG])
#define BG(dc, col)  ((col)[(dc)->invert ? ColFG : ColBG])
#define MAX(a,b)              ((a) > (b) ? (a) : (b))
enum { ColBG, ColFG, ColBorder, ColLast };

typedef struct {
	int x, y, w, h;
	Bool invert;
	Display *dpy;
	GC gc;
	Pixmap canvas;
	struct {
		int ascent;
		int descent;
		int height;
		int width;
		XFontSet set;
		XFontStruct *xfont;
	} font;
} DC;  /* draw context */

void drawrect(DC *dc, int x, int y, unsigned int w, unsigned int h, Bool fill, unsigned long color);
size_t drawtext(DC *dc, const char *text, int, int,unsigned long col);
void freedc(DC *dc);
unsigned long getcolor(DC *dc, const char *colstr);
DC *initdc(void);
void initfont(DC *dc, const char *fontstr);
void mapdc(DC *dc, Window win, unsigned int w, unsigned int h);
void resizedc(DC *dc, unsigned int w, unsigned int h);
int textnw(DC *dc, const char *text, size_t len);
int textw(DC *dc, const char *text);
