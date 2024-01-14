/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   testsegv.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: corellan <corellan@student.hive.fi>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/01/13 17:03:01 by corellan          #+#    #+#             */
/*   Updated: 2024/01/13 17:03:02 by corellan         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <string.h>
#include <stdio.h>

int	main(void)
{
	char	*str;
	size_t	size;

	str = NULL;
	size = strlen(str);
	printf("%zu\n", size);
	return (0);
}
