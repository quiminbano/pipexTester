/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   mock_malloc_1.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: corellan <corellan@student.hive.fi>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/01/13 17:31:05 by corellan          #+#    #+#             */
/*   Updated: 2024/01/15 01:01:18 by corellan         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <unistd.h>
#include <dlfcn.h>
#include <string.h>
#ifdef RUNNING_ON_VALGRIND
# include <valgrind/memcheck.h>
#endif

void	*malloc(size_t size)
{
	static size_t	count = 0;
	void			*handler;
	void			*content;

	#ifdef __x86_64__
		handler = dlopen("/lib/ld-musl-x86_64.so.1", RTLD_LAZY);
	#endif
	#ifdef __aarch64__
		handler = dlopen("/lib/ld-musl-aarch64.so.1", RTLD_LAZY);
	#endif
	if (!handler)
	{
		write(2, dlerror(), strlen(dlerror()));
		return (NULL);
	}
	void *(*orig_malloc)(size_t) = dlsym(handler, "malloc");
	if (!orig_malloc)
	{
		write(2, dlerror(), strlen(dlerror()));
		dlclose(handler);
		return (NULL);
	}
	#ifndef RUNNING_ON_VALGRIND
	if (count >= 1)
	{
		dlclose(handler);
		return (NULL);
	}
	#endif
	content = (*orig_malloc)(size);
	count++;
	dlclose(handler);
	return (content);
}
