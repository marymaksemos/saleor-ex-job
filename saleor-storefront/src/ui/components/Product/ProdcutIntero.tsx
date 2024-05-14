"use client";
import NextImage from "next/image";
import { useState } from "react";
import { cn } from "@/lib/utils";
import { type ProductMedia } from "@/gql/graphql";

interface ProductIntroProps {
	images?: ProductMedia[];
	thumbnails?: ProductMedia[];
}

export function ProductIntro({ images = [], thumbnails = [] }: ProductIntroProps) {
	const [selectedImage, setSelectedImage] = useState(images[0]);

	const selectedImageHandler = (id: string) => () => {
		const selected = images.find((image) => image.id === id);
		if (selected) setSelectedImage(selected);
	};

	return (
		<div>
			<div className="relative mb-4 aspect-square overflow-hidden rounded-lg border bg-white p-4">
				{selectedImage && (
					<NextImage
						className="h-full w-full object-contain object-center"
						src={selectedImage.url}
						alt={selectedImage.alt ?? ""}
						width={1024}
						height={1024}
						quality={100}
						placeholder="blur"
						blurDataURL={thumbnails.find((image) => image.id === selectedImage.id)?.url ?? ""}
					/>
				)}
			</div>
			<ul className="items-cneter flex flex-wrap justify-center gap-2 md:gap-4">
				{thumbnails.map(({ id, url, alt }) => (
					<li
						key={id}
						onClick={selectedImageHandler(id)}
						className={cn(
							"aspect-square basis-10 cursor-pointer overflow-hidden rounded-md border bg-white p-0.5 outline-none md:basis-20 md:p-1",
							{ "border-orange-500": selectedImage.id == id },
						)}
					>
						<div className="relative h-full w-full">
							<NextImage
								className="h-full w-full object-contain object-center"
								src={url}
								alt={alt}
								width={80}
								height={80}
							/>
						</div>
					</li>
				))}
			</ul>
		</div>
	);
}
