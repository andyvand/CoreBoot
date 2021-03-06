// See license at end of file

/* For gcc, compile with -fno-builtin to suppress warnings */

#include "1275.h"

#include <string.h>
#include <stdarg.h>
#include "stdio.h"

long
memtol(const char *s, int len, char **endptr, int base)
{
	int temp = 0;
	int minus = 0;
	int digit;
	const char *send = s+len;

	if (s != send && (*s == '+' || *s == '-')) {
		minus = *s == '-';
		s++;
	}
	if (base == 0) {
		if (s!=send && *s == '0') {
			++s;
			if (s!=send && toupper(*s) == 'X') {
				++s;
				base = 16;
			} else {
				base = 8;
			}
		} else {
			base = 10;    
		}
        } else {
		if (base == 16 && (send-s) > 1 && *s == '0' && toupper(s[1]) == 'X') {
			s += 2;
		}
	}
	while (s!=send) {
		digit = toupper(*s) - '0';
		if (digit >= 0 && digit <= 9) {
			temp = (temp * base) + digit;
			s++;
		} else {
			digit = digit + '0' - 'A' + 10;
			if (digit >= 10 && digit < base) {
				temp = (temp * base) + digit;
				s++;
			} else {
				break;
			}
		}
	}
	if (endptr)
		*endptr = (char *)s;
	return minus ? -temp : temp;
}

long
strtol(const char *s, char **endptr, int base)
{
	return memtol(s, strlen(s), endptr, base);
}

int
atoi(const char *s)
{
	return (int)strtol(s, NULL, 10);
}

static int
printbase(ULONG x, int base, int fieldlen, char padchar, int upcase)
{
	static char lc_digits[] = "0123456789abcdef";
	static char uc_digits[] = "0123456789ABCDEF";
	ULONG j;
	char buf[32], *s = buf;
	int n = 0;

	memset(buf, 32, 0);

	if (base == 10 && (long) x < 0) {
		*s++ = '-';
		x = -x;
	}

	do {
		j = x % base;
		*s++ = upcase ? uc_digits[j] : lc_digits[j];
		x -= j;
		x /= base;
	} while (x);

	for (fieldlen -= (s-buf); fieldlen > 0; --fieldlen) {
		putchar(padchar);
		n++;
	}

	for (--s; s >= buf; --s) {
		putchar(*s);
		n++;
	}

	return (n);
}

int
_printf(char *fmt, va_list args)
{
	ULONG x;
	char c, *s;
	int n = 0;
        int fieldlen;
        unsigned long mask;
	char padchar;

	while ((c = *fmt++)) {
		if (c != '%') {
			putchar(c);
			n++;
			continue;
		}
                mask = 0xffffffff;
                if ((c = *fmt++) == '\0')
			goto out;
		
		if (c == '.')        // Ignore the numeric grouping flag
			if ((c = *fmt++) == '\0')
				goto out;

		padchar = ' ';
		if (c == '0') {
			padchar = c;
			if ((c = *fmt++) == '\0')
				goto out;
		}

                fieldlen = 0;
                while (c >= '0' && c <= '9') {
			fieldlen = (fieldlen * 10) + (c - '0');
			if ((c = *fmt++) == '\0')
				goto out;
		}

                if (c == 'l') {	// Ignore "long" modifier
			if ((c = *fmt++) == '\0')
				goto out;
                }
                while (c == 'h') {	// Mask for short modifier
			if (mask == 0xffff)
				mask = 0xff;
			else
				mask = 0xffff;
			if ((c = *fmt++) == '\0')
				goto out;
                }

		switch (c) {
		case 'x':
			x = va_arg(args, ULONG) & mask;
			n += printbase(x, 16, fieldlen, padchar, 0);
			break;
		case 'X':
			x = va_arg(args, ULONG) & mask;
			n += printbase(x, 16, fieldlen, padchar, 1);
			break;
		case 'o':
			x = va_arg(args, ULONG) & mask;
			n += printbase(x, 8, fieldlen, padchar, 0);
			break;
		case 'd':
			x = va_arg(args, ULONG) & mask;
			n += printbase(x, 10, fieldlen, padchar, 0);
			break;
		case 'c':
			c = va_arg(args, int);
			putchar(c);
			n++;
			break;
		case 's':
			s = va_arg(args, char *);
			while (*s) {
				putchar(*s++);
				n++;
			}
			break;
		default:
			putchar(c);
			n++;
			break;
		}
	}
out:
	return(n);
}

int
printf(char *fmt, ...)
{
	va_list args;
	int i;

	va_start(args, fmt);
	i = _printf(fmt, args);
	va_end(args);
        fflush(stdout);
	return (i);
}

void
warn(char *fmt, ...)
{
	va_list args;

	va_start(args, fmt);
	(void)_printf(fmt, args);
	va_end(args);
}

void
fatal(char *fmt, ...)
{
	va_list args;

	va_start(args, fmt);
	(void)_printf(fmt, args);
	va_end(args);
	exit(1);
} 

// LICENSE_BEGIN
// Copyright (c) 2006 FirmWorks
// 
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// LICENSE_END
